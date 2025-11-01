import 'package:centranews/utils/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_data.dart';
import '../providers/theme_provider.dart';
import '../widgets/article_container.dart';

final supabase = Supabase.instance.client;

const List<String> discoveredQueryParams = ["Politics"];

//TODO: implement this discover page using different algorithm
class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> with Pagination {
  List<ArticleData> discoveredArticles = [];
  final ScrollController scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(onScroll);
    return discoverPage();
  }

  Widget discoverPage() {
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              backgroundColor: currentTheme.currentColorScheme.bgPrimary,
              color: currentTheme.currentColorScheme.bgInverse,
              onRefresh: () async {
                onRefresh();
              },

              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: GridView.builder(
                  gridDelegate: pageGridDelegate,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: pageEdgeInset,
                  itemCount: discoveredArticles.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    try {
                      if (index == discoveredArticles.length) {
                        if (discoveredArticles.isEmpty && isLoading) {
                          return displayCircularProgressBar(currentTheme);
                        }
                      }
                      return ArticleContainer(
                        articleData: discoveredArticles[index],
                        key: UniqueKey(),
                      );
                    } catch (e) {
                      return displayCircularProgressBar(currentTheme);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() async {
    if (isTheEndOfThePage(scrollController)) {
      try {
        if (mounted) {
          setState(() {
            increaseCurrentPage();
          });
        }

        await fetchMoreDiscoveredArticles(context);
      } catch (e) {
        debugPrint(e.toString());
        if (mounted) {
          setState(() {
            decreaseCurrentPage();
          });
        }
      }
    }
  }

  Future<void> fetchMoreDiscoveredArticles(BuildContext context) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var response = await getDiscoveredArticles();
      List<ArticleData> discoveredArticlesFromResponse = [];
      for (var value in response) {
        discoveredArticlesFromResponse.add(ArticleData.fromJson(value));
      }
      if (discoveredArticlesFromResponse.isNotEmpty) {
        if (mounted) {
          setState(() {
            discoveredArticles = [
              ...discoveredArticles,
              ...discoveredArticlesFromResponse,
            ];
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> getDiscoveredArticles() async {
    return supabase
        .from('articles')
        .select()
        .contains('categories', discoveredQueryParams)
        .order('created_at', ascending: false)
        .range(startIndex, endIndex);
  }

  void onRefresh() async {
    if (mounted) {
      setState(() {
        resetCurrentPage();
        isLoading = true;
      });
    }

    try {
      var response = await getDiscoveredArticles();
      if (mounted) {
        setState(() {
          discoveredArticles = [];
        });
      }
      var newDiscoveredArticlesList = [];
      for (var value in response) {
        newDiscoveredArticlesList.add(ArticleData.fromJson(value));
      }
      if (newDiscoveredArticlesList.isNotEmpty) {
        if (mounted) {
          setState(() {
            discoveredArticles = [
              ...discoveredArticles,
              ...newDiscoveredArticlesList,
            ];
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
