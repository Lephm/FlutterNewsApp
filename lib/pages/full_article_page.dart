import 'package:centranews/models/article_data.dart';
import 'package:centranews/utils/format_string_helper.dart';
import 'package:centranews/utils/full_screen_overlay_progress_bar.dart';
import 'package:centranews/widgets/article_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_info.dart';
import '../providers/local_user_provider.dart';
import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/article_data_retrieve_helper.dart';
import '../utils/bookmark_manager.dart';
import '../utils/pop_up_message.dart';
import '../widgets/article_label.dart';
import '../widgets/custom_safe_area.dart';

final supabase = Supabase.instance.client;
const double thumbnailImageHeight = 300;

class FullArticlePage extends ConsumerStatefulWidget {
  const FullArticlePage({super.key, this.arg});

  final String? arg;

  @override
  ConsumerState<FullArticlePage> createState() => _FullArticlePageState();
}

class _FullArticlePageState extends ConsumerState<FullArticlePage>
    with FullScreenOverlayProgressBar {
  String articleID = "";
  bool _isLoading = true;
  ArticleData? articleData;
  List<ArticleData> relatedArticles = [];
  bool isBookmarked = false;
  int? bookmarkCount;

  Future<void> loadBookmarkStateStartUp(ArticleData data) async {
    try {
      var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
        data.articleID,
      );
      var bookmarkCountData = await BookmarkManager.getBookmarkCount(
        data.articleID,
      );
      if (mounted) {
        setState(() {
          isBookmarked = articleIsBookmarked;
          bookmarkCount = bookmarkCountData;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget bookmarkButton() {
    var currentTheme = ref.watch(themeProvider);
    var localUser = ref.watch(userProvider);
    return Row(
      children: [
        Text(
          bookmarkCount != null
              ? bookmarkCount.toString()
              : articleData != null
              ? articleData!.bookmarkCount.toString()
              : 0.toString(),
          style: currentTheme.textTheme.bodySmall,
        ),
        IconButton(
          onPressed: () {
            toggleBookmark();
          },
          icon: (isBookmarked && (localUser != null))
              ? Icon(
                  Icons.bookmark,
                  color: currentTheme.currentColorScheme.bgInverse,
                )
              : Icon(
                  Icons.bookmarks_outlined,
                  color: currentTheme.currentColorScheme.bgInverse,
                ),
        ),
      ],
    );
  }

  void toggleBookmark() async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var localUser = ref.watch(userProvider);
    if (localUser == null) {
      showSignInPrompt(context, currentTheme, localization);
      return;
    }
    try {
      if (mounted) {
        showProgressBar(context, currentTheme);
      }
      if (isBookmarked) {
        await BookmarkManager.removeArticleIdFromBookmark(
          localUser.uid,
          articleData!.articleID,
          (bookmarkCount != null)
              ? bookmarkCount ?? 0
              : articleData != null
              ? articleData!.bookmarkCount
              : 0,
        );
      } else {
        await BookmarkManager.addArticleIdToBookmark(
          localUser.uid,
          articleData!.articleID,
          (bookmarkCount != null)
              ? bookmarkCount ?? 0
              : articleData != null
              ? articleData!.bookmarkCount
              : 0,
        );
      }
      await loadBookmarkState();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        closeProgressBar(context);
      }
    }
  }

  Future<void> loadBookmarkState() async {
    try {
      if (supabase.auth.currentUser == null) return;

      var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
        articleData!.articleID,
      );
      var bookmarkCountData = await BookmarkManager.getBookmarkCount(
        articleData!.articleID,
      );
      if (mounted) {
        setState(() {
          isBookmarked = articleIsBookmarked;
          bookmarkCount = bookmarkCountData;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    if (_isLoading == true) {
      fetchArticle();
    }

    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
          leading: BackButton(
            color: currentTheme.currentColorScheme.bgInverse,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            (_isLoading || articleData == null)
                ? SizedBox.shrink()
                : bookmarkButton(),
          ],
          title: Center(child: appIcon()),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: _isLoading
            ? displayCircularProgressBar()
            : ((articleData == null)
                  ? displayErrorPage()
                  : displayArticlePage()),
      ),
    );
  }

  Widget appIcon() {
    var currentTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Flexible(
              child: Image(
                image: AssetImage("assets/app_icon.png"),
                height: 30,
                color: currentTheme.currentColorScheme.bgInverse,
              ),
            ),
            Flexible(
              child: Text(
                AppInfo.title,
                style: currentTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchRelatedArticles() async {
    try {
      final articleId = widget.arg as String;
      final response = await Supabase.instance.client.rpc(
        'get_similar_articles',
        params: {"current_article_id": articleId},
      );
      List<ArticleData> datas = [];
      for (var value in response) {
        datas.add(ArticleData.fromJson(value));
      }
      if (mounted) {
        setState(() {
          relatedArticles = [...datas];
        });
      }
    } catch (e) {
      debugPrint('Error calling RPC: $e');
    }
  }

  Widget displayErrorPage() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(
              localization.cantFindRelevantArticles,
              style: currentTheme.textTheme.bodyMediumBold,
            ),
            BackButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayArticlePage() {
    fetchRelatedArticles();
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            displayCurrentArticle(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Text(
                    localization.relatedArticles,
                    style: currentTheme.textTheme.headlineMedium,
                  ),
                  renderRelatedArticlesIfSuitable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayCurrentArticle() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var formattedSummaryText = formatSummaryText(articleData!.articleSummary);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: currentTheme.currentColorScheme.bgPrimary,
        ),
        constraints: BoxConstraints(maxWidth: 800),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            displayCategoriesLabels(),

            SelectableText(
              articleData!.articleTitle,
              style: currentTheme.textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
            Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: currentTheme.currentColorScheme.textSecondary,
                ),
                Text(
                  articleData!.date,
                  style: currentTheme.textTheme.bodyLightMedium,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              children: [
                ArticleLabel(
                  content: articleData!.publisher,
                  leadingIcon: Icon(
                    Icons.newspaper,
                    color: currentTheme.currentColorScheme.bgInverse,
                    size: 14,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                articleData!.thumbnailUrl,
                errorBuilder: (context, error, stackTrace) =>
                    displayThumbnailErrorWidget(),
                width: double.infinity,
                height: thumbnailImageHeight,
                fit: BoxFit.fitHeight,
              ),
            ),
            SelectableText(
              formattedSummaryText,
              style: currentTheme.textTheme.bodySmall,
              textAlign: TextAlign.justify,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                localization.sources,
                style: currentTheme.textTheme.bodyBold,
              ),
            ),
            displayGoToSourceButton(),
          ],
        ),
      ),
    );
  }

  Widget displayCategoriesLabels() {
    var localization = ref.watch(localizationProvider);
    var categoryContainers = <Widget>[];
    if (articleData == null) {
      return SizedBox.shrink();
    }
    if (articleData != null) {
      for (int i = 0; i < articleData!.categories.length; i++) {
        categoryContainers.add(
          ArticleLabel(
            content: localization.getLocalLanguageLabelText(
              articleData!.categories[i],
            ),
            inversed: true,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 5,
          children: categoryContainers,
        ),
      ],
    );
  }

  Widget renderRelatedArticlesIfSuitable() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return (relatedArticles.isEmpty)
        ? Text(
            localization.cantFindRelevantArticles,
            style: currentTheme.textTheme.bodyMediumBold,
          )
        : displayRelatedArticles();
  }

  Widget displayRelatedArticles() {
    List<ArticleContainer> articles = [];
    for (var article in relatedArticles) {
      articles.add(
        ArticleContainer(
          articleData: article,
          key: ValueKey(article.articleID),
        ),
      );
    }
    return Column(spacing: 30, children: articles);
  }

  Widget displayCircularProgressBar() {
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  Future<void> fetchArticle() async {
    try {
      final arg = widget.arg;
      articleID = arg as String;
      final data = await supabase
          .from("articles")
          .select(ARTICLESSELECTPARAMETER)
          .eq("article_id", articleID)
          .single();
      var currentArticleData = ArticleData.fromJson(data);
      await loadBookmarkStateStartUp(currentArticleData);
      if (mounted) {
        setState(() {
          articleData = currentArticleData;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget displayThumbnailErrorWidget() {
    return SizedBox.shrink();
  }

  Widget displayGoToSourceButton() {
    var currentTheme = ref.watch(themeProvider);
    return TextButton(
      onPressed: () async {
        try {
          await launchUrl(Uri.parse(articleData!.source));
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      child: Row(
        spacing: 10,
        children: [
          Icon(Icons.link, color: currentTheme.currentColorScheme.bgInverse),
          Expanded(
            child: Text(
              articleData!.source,
              style: currentTheme.textTheme.hyperlinkSourceStyle,
            ),
          ),
        ],
      ),
    );
  }
}
