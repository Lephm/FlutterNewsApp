import 'package:centranews/providers/main_articles_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/article_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/article_data.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  bool hasFetchDataForTheFirstTime = false;

  @override
  Widget build(BuildContext context) {
    var mainArticleProvider = ref.watch(mainArticlesProvider.notifier);
    var mainArticleProviderRead = ref.watch(mainArticlesProvider);
    var currentTheme = ref.watch(themeProvider);
    _scrollController.addListener(_onScroll);
    fetchDataForFirstTime(context);
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
                debugPrint("refresh articles data");
                mainArticleProvider.refereshArticlesData(context: context);
              },

              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  itemCount:
                      mainArticleProviderRead.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == mainArticleProviderRead.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor:
                              currentTheme.currentColorScheme.bgPrimary,
                          color: currentTheme.currentColorScheme.bgInverse,
                        ),
                      );
                    }
                    return ArticleContainer(
                      articleData: mainArticleProviderRead[index],
                    );
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
    _scrollController.dispose();
    super.dispose();
  }

  //TODO: fully implement pagination
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      debugPrint("Fetch new articles");
    }
  }

  Future<void> _fetchArticlesList(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    var mainArticleProviders = ref.watch(mainArticlesProvider.notifier);
    await mainArticleProviders.fetchArticlesData(context: context);
    setState(() {
      _isLoading = false;
    });
  }

  void fetchDataForFirstTime(BuildContext context) {
    if (hasFetchDataForTheFirstTime == false) {
      _fetchArticlesList(context);
      setState(() {
        hasFetchDataForTheFirstTime = true;
      });
    }
  }
}
