import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/main_articles_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/pagination.dart';
import 'package:centranews/widgets/article_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const numberOfArticlesBeforeShowingBannerAd = 1;

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
  List<String> currentQueryCategories = [];

  @override
  Widget build(BuildContext context) {
    var mainArticles = ref.watch(mainArticlesProvider);
    var currentTheme = ref.watch(themeProvider);
    var queryCategories = ref.watch(queryCategoriesProvider);
    if (currentQueryCategories != queryCategories) {
      refreshDataToRefelectSearchQueries();
    }
    scrollController.addListener(onScroll);
    if (mounted && !hasFetchDataForTheFirstTime) {
      if (mainArticles.isEmpty) {
        fetchDataForFirstTime();
      } else {
        setState(() {
          hasFetchDataForTheFirstTime = true;
        });
      }
    }
    return (mainArticles.isEmpty && !isLoading && queryCategories.isNotEmpty)
        ? displayCantFindRelevantArticles()
        : Center(
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
                        padding: pageEdgeInset,
                        itemCount: mainArticles.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          try {
                            if (index == mainArticles.length) {
                              if (queryCategories.isEmpty && isLoading) {
                                return displayCircularProgressBar(currentTheme);
                              }
                            }
                            return ArticleContainer(
                              articleData: mainArticles[index],
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

  void refreshDataToRefelectSearchQueries() {
    var queryCategories = ref.watch(queryCategoriesProvider);
    scrollToTop(scrollController);
    if (mounted) {
      setState(() {
        currentQueryCategories = queryCategories;
      });
    }
    refreshData();
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
    var queryCategoriesList = ref.watch(queryCategoriesProvider);
    try {
      await mainArticleNotifier.fetchArticlesData(
        context: context,
        startIndex: startIndex,
        endIndex: endIndex,
        queryParams: queryCategoriesList,
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
        isLoading = true;
      });
      try {
        await mainArticleNotifier.refereshArticlesData(
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
            isLoading = false;
          });
        }
      }
    }
  }

  Widget displayCantFindRelevantArticles() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        localization.cantFindRelevantArticles,
        style: currentTheme.textTheme.bodyMediumBold,
      ),
    );
  }

  void refreshData() async {
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    var queryCategoriesList = ref.watch(queryCategoriesProvider);
    setState(() {
      resetCurrentPage();
      isLoading = true;
    });
    debugPrint("refresh articles data");
    await mainArticleNotifier.refereshArticlesData(
      context: context,
      startIndex: startIndex,
      endIndex: endIndex,
      queryParams: queryCategoriesList,
    );
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
