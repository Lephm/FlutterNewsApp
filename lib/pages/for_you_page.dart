import 'dart:math';

import 'package:centranews/utils/article_data_retrieve_helper.dart';
import 'package:centranews/utils/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_data.dart';
import '../providers/theme_provider.dart';
import '../utils/categories_list.dart';
import '../widgets/article_container.dart';

final supabase = Supabase.instance.client;

const List<String> defaultForYouQueryParams = ["Politics"];

//TODO: implement this discover page using different algorithm
class ForYouPage extends ConsumerStatefulWidget {
  const ForYouPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForYouPageState();
}

class _ForYouPageState extends ConsumerState<ForYouPage> with Pagination {
  static bool hasLoadCurrentUserPreferedCategory = false;
  List<ArticleData> forYouArticles = [];
  final ScrollController scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<String>? forYouQueryParams;
  bool hasFinishedLoadingForTheFirstTime = false;

  @override
  void initState() {
    super.initState();
    loadForYouQueryParams();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(onScroll);
    var currentTheme = ref.watch(themeProvider);
    return (forYouQueryParams == null ||
            forYouArticles.isEmpty ||
            !hasFinishedLoadingForTheFirstTime)
        ? displayCircularProgressBar(currentTheme)
        : forYouPage();
  }

  Future<void> loadForYouQueryParams() async {
    if (mounted) {
      setState(() {
        hasFinishedLoadingForTheFirstTime = false;
      });
    }
    if (supabase.auth.currentUser != null &&
        !hasLoadCurrentUserPreferedCategory) {
      hasLoadCurrentUserPreferedCategory = true;
      try {
        await loadUserForYouQueryParams();
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      if (supabase.auth.currentUser == null) {
        hasLoadCurrentUserPreferedCategory = false;
        if (mounted) {
          setState(() {
            hasFinishedLoadingForTheFirstTime = true;
          });
        }
      }
      if (mounted &&
          forYouQueryParams != defaultForYouQueryParams &&
          forYouQueryParams == null) {
        setState(() {
          forYouQueryParams = defaultForYouQueryParams;
          hasFinishedLoadingForTheFirstTime = true;
        });
        refreshForYouArticles();
      }
    }
  }

  Future<void> loadUserForYouQueryParams() async {
    debugPrint("load user prefered query param");
    final random = Random();
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('user_prefered_category')
          .select()
          .eq("user_id", supabase.auth.currentUser!.id)
          .order("created_at", ascending: random.nextBool())
          .limit(2);
      List<String> userPreferedCategoryResponse = [];
      for (var value in data) {
        if (categories.contains(value["category"].toString())) {
          userPreferedCategoryResponse.add(value["category"].toString());
          debugPrint(userPreferedCategoryResponse.toString());
        }
      }
      if (mounted) {
        setState(() {
          forYouQueryParams = userPreferedCategoryResponse;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await refreshForYouArticles();
        }
        shouldRefreshDataIfCantFindArticlesBasedOnUserPreferedQueryCategories();
      });
    } catch (error) {
      debugPrint('$error');
    }
  }

  bool isValidForYouArticleLength() {
    return forYouArticles.length >= (itemPerPage - 5);
  }

  void shouldRefreshDataIfCantFindArticlesBasedOnUserPreferedQueryCategories() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isValidForYouArticleLength()) {
        setState(() {
          forYouQueryParams = defaultForYouQueryParams;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            await refreshForYouArticles();
            if (mounted) {
              setState(() {
                hasFinishedLoadingForTheFirstTime = true;
              });
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            hasFinishedLoadingForTheFirstTime = true;
          });
        }
      }
    });
  }

  Widget forYouPage() {
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
                refreshForYouArticles();
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
                  itemCount: forYouArticles.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    try {
                      if (index == forYouArticles.length) {
                        if (forYouArticles.isEmpty && isLoading) {
                          return displayCircularProgressBar(currentTheme);
                        }
                      }
                      return ArticleContainer(
                        articleData: forYouArticles[index],
                        key: ValueKey(forYouArticles[index].articleID),
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
    hasLoadCurrentUserPreferedCategory = false;
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

        await fetchMoreForYouArticles(context);
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

  Future<void> fetchMoreForYouArticles(BuildContext context) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var response = await getForYouArticles();
      List<ArticleData> forYouArticlesFromResponse = [];
      for (var value in response) {
        forYouArticlesFromResponse.add(ArticleData.fromJson(value));
      }
      if (forYouArticlesFromResponse.isNotEmpty) {
        if (mounted) {
          setState(() {
            forYouArticles = getUniqueArticleDatas(
              forYouArticles,
              forYouArticlesFromResponse,
            );
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

  Future<List<Map<String, dynamic>>> getForYouArticles() async {
    return supabase
        .from('articles')
        .select()
        .overlaps('categories', forYouQueryParams ?? defaultForYouQueryParams)
        .order('created_at', ascending: false)
        .order('article_id', ascending: true)
        .range(startIndex, endIndex);
  }

  Future<void> refreshForYouArticles() async {
    if (mounted) {
      setState(() {
        resetCurrentPage();
        isLoading = true;
      });
    }

    try {
      var response = await getForYouArticles();
      if (mounted) {
        setState(() {
          forYouArticles = [];
        });
      }
      var newForYouArticlesList = [];
      for (var value in response) {
        newForYouArticlesList.add(ArticleData.fromJson(value));
      }
      if (newForYouArticlesList.isNotEmpty) {
        if (mounted) {
          newForYouArticlesList.shuffle();
          List<ArticleData> randomizedArticlesList = [...newForYouArticlesList];
          setState(() {
            forYouArticles = [...forYouArticles, ...randomizedArticlesList];
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
