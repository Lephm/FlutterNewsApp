import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/main_articles_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/pagination.dart';
import 'package:centranews/widgets/article_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> with Pagination {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  bool hasFetchDataForTheFirstTime = false;
  var queryParams = <String>[];

  @override
  Widget build(BuildContext context) {
    var mainArticles = ref.watch(mainArticlesProvider);
    var currentTheme = ref.watch(themeProvider);
    scrollController.addListener(onScroll);
    if (!hasFetchDataForTheFirstTime) {
      fetchDataForFirstTime();
    }
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
                refreshData();
              },

              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: GridView.builder(
                  gridDelegate: pageGridDelegate,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  itemCount: mainArticles.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == mainArticles.length) {
                      if (queryParams.isEmpty && isLoading) {
                        return displayCircularProgressBar(currentTheme);
                      }
                      return displayCantFindRelevantArticles();
                    }
                    return ArticleContainer(articleData: mainArticles[index]);
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
      debugPrint("Fetch new articles");
      try {
        setState(() {
          increaseCurrentPage();
        });
        await fetchMoreArticlesList(context);
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          decreaseCurrentPage();
        });
      }
    }
  }

  Future<void> fetchMoreArticlesList(BuildContext context) async {
    if (currentPage == 0) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    try {
      await mainArticleNotifier.fetchArticlesData(
        context: context,
        startIndex: startIndex,
        endIndex: endIndex,
      );
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

  void fetchDataForFirstTime() async {
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    var mainArticles = ref.watch(mainArticlesProvider);
    if (mainArticles.isEmpty) {
      setState(() {
        resetCurrentPage();
        hasFetchDataForTheFirstTime = true;
      });
      try {
        await mainArticleNotifier.fetchArticlesData(
          context: context,
          startIndex: startIndex,
          endIndex: endIndex,
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        if (mounted) {
          setState(() {
            hasFetchDataForTheFirstTime = true;
          });
        }
      }
    }
  }

  Widget displayCantFindRelevantArticles() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Text(
      localization.cantFindRelevantArticles,
      style: currentTheme.textTheme.bodyMediumBold,
    );
  }

  void refreshData() {
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    setState(() {
      resetCurrentPage();
    });
    debugPrint("refresh articles data");
    mainArticleNotifier.refereshArticlesData(
      context: context,
      startIndex: startIndex,
      endIndex: endIndex,
    );
  }
}
