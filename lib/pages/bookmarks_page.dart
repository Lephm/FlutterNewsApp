import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/bookmark_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/pagination.dart';
import '../widgets/article_container.dart';

final supabase = Supabase.instance.client;

class BookmarksPage extends ConsumerStatefulWidget {
  const BookmarksPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarksPageState();
}

//TODO: Fix bookmark page error
class _BookmarksPageState extends ConsumerState<BookmarksPage> with Pagination {
  List<ArticleData> bookmarkArticles = [];
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
    var localUser = ref.watch(userProvider);
    scrollController.addListener(onScroll);
    if (localUser != null && !isLoading && bookmarkArticles.isEmpty) {
      return displayYouDoNotHaveAnyBookmarks();
    }
    return localUser == null ? notLoginPrompt() : bookmarkPage();
  }

  Widget notLoginPrompt() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              localization.youMustSignInPrompt,
              style: currentTheme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/sign_in");
              },
              child: Text(
                localization.signIn,
                style: currentTheme.textTheme.bodyMediumBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookmarkPage() {
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  itemCount: bookmarkArticles.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    try {
                      if (index == bookmarkArticles.length) {
                        if (bookmarkArticles.isEmpty && isLoading) {
                          return displayCircularProgressBar(currentTheme);
                        }
                      }
                      return ArticleContainer(
                        articleData: bookmarkArticles[index],
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

  Widget displayYouDoNotHaveAnyBookmarks() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          localization.youDoNotHaveAnyBookmark,
          style: currentTheme.textTheme.bodyMediumBold,
        ),
      ),
    );
  }

  void onScroll() async {
    if (isTheEndOfThePage(scrollController)) {
      try {
        setState(() {
          increaseCurrentPage();
        });
        await fetchMoreBookmarkArticles(context);
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          decreaseCurrentPage();
        });
      }
    }
  }

  Future<void> fetchMoreBookmarkArticles(BuildContext context) async {
    var localUser = ref.watch(userProvider);
    if (localUser == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      var bookmarkArticlesList = await BookmarkManager.getBookmarkArticles(
        startIndex,
        endIndex,
      );
      if (bookmarkArticlesList.isNotEmpty) {
        setState(() {
          bookmarkArticles = [...bookmarkArticles, ...bookmarkArticlesList];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onRefresh() async {
    setState(() {
      resetCurrentPage();
      bookmarkArticles = [];
      isLoading = true;
    });
    try {
      var bookmarkArticlesList = await BookmarkManager.getBookmarkArticles(
        startIndex,
        endIndex,
      );
      if (bookmarkArticlesList.isNotEmpty) {
        setState(() {
          bookmarkArticles = [...bookmarkArticles, ...bookmarkArticlesList];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
