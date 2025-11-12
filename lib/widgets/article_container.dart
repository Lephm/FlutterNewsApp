import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/bookmark_manager.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:centranews/utils/format_string_helper.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:centranews/widgets/article_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/full_screen_overlay_progress_bar.dart';
import '../utils/pagination.dart';

const double containerBorderRadius = 10;
const double containerHorizontalLabelPadding = 5;
final supabase = Supabase.instance.client;
const double thumbnailImageHeight = 300;

class ArticleContainer extends ConsumerStatefulWidget {
  const ArticleContainer({super.key, required this.articleData});

  final ArticleData articleData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleContainer();
}

class _ArticleContainer extends ConsumerState<ArticleContainer>
    with FullScreenOverlayProgressBar {
  bool isBookmarked = false;
  bool cantLoadImage = false;
  int bookmarkCount = 0;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    loadBookmarkStateStartUp();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: currentTheme.currentColorScheme.bgPrimary,
        border: Border.all(
          width: 0.2,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
      ),
      width: 600,
      height: Pagination.mainAxisExtendHeight,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Column(
            spacing: 5,
            children: [
              displayThumbnail(),
              displayPublishedDate(),
              displayTitle(),
              displaySecondaryLabels(),
              displaySummaryText(),
              displayHyperlinkButtonOptions(),
            ],
          ),
          displayCategoriesLabels(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget displayCategoriesLabels() {
    var localization = ref.watch(localizationProvider);
    var categoryContainers = <Widget>[];
    for (int i = 0; i < widget.articleData.categories.length; i++) {
      if (i < 4) {
        categoryContainers.add(
          ArticleLabel(
            content: localization.getLocalLanguageLabelText(
              widget.articleData.categories[i],
            ),
            inversed: true,
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: containerHorizontalLabelPadding,
      ),
      child: Column(
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
      ),
    );
  }

  Widget displayThumbnail() {
    return Flexible(
      flex: 2,
      child: TextButton(
        onPressed: () {
          goToFullArticlePage();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(containerBorderRadius),
          child: Image.network(
            widget.articleData.thumbnailUrl,
            errorBuilder: (context, error, stackTrace) {
              if (!cantLoadImage) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      cantLoadImage = true;
                    });
                  }
                });
              }
              return displayThumbnailErrorWidget();
            },
            width: double.infinity,
            height: thumbnailImageHeight,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }

  Widget displayThumbnailErrorWidget() {
    return SizedBox(width: double.infinity, height: 60);
  }

  Widget displayPublishedDate() {
    var currentTheme = ref.watch(themeProvider);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: containerHorizontalLabelPadding,
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            size: 20,
            color: currentTheme.currentColorScheme.textSecondary,
          ),
          SizedBox(width: 8),
          Text(
            widget.articleData.date,
            style: currentTheme.textTheme.bodyLightMedium,
          ),
        ],
      ),
    );
  }

  Widget displayTitle() {
    var currentTheme = ref.watch(themeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: TextButton(
            onPressed: () {
              goToFullArticlePage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: containerHorizontalLabelPadding,
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                widget.articleData.articleTitle,
                style: currentTheme.textTheme.bodyMediumBold,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
        displayShareAndBookmarkButton(),
      ],
    );
  }

  Widget displayShareAndBookmarkButton() {
    var currentTheme = ref.watch(themeProvider);
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          SizedBox(width: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              bookmarkCount.toString(),
              style: currentTheme.textTheme.bodyMedium,
            ),
          ),
          bookmarkButton(),
        ],
      ),
    );
  }

  //TODO: implement this and add it to displayShareAndBookMarkButton
  Widget shareButton() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return IconButton(
      onPressed: () async {
        final articleId = widget.articleData.articleID;
        final linkToCopied =
            "${CustomNavigatorSettings.domainName}/#/full_article/$articleId";
        await Clipboard.setData(ClipboardData(text: linkToCopied));

        if (mounted) {
          showAlertMessage(
            context,
            localization.copiedSucessfully,
            currentTheme,
          );
        }
      },
      icon: Icon(Icons.share, color: currentTheme.currentColorScheme.bgInverse),
    );
  }

  Widget bookmarkButton() {
    var currentTheme = ref.watch(themeProvider);
    var localUser = ref.watch(userProvider);
    return IconButton(
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
    );
  }

  Future<void> loadBookmarkStateStartUp() async {
    if (supabase.auth.currentUser == null) return;
    var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
      supabase.auth.currentUser!.id,
      widget.articleData.articleID,
    );
    var bookmarkCountData = await supabase
        .from('bookmarks')
        .select()
        .eq('article_id', widget.articleData.articleID)
        .count(CountOption.exact);
    if (mounted) {
      setState(() {
        isBookmarked = articleIsBookmarked;
        bookmarkCount = bookmarkCountData.count;
      });
    }
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
      if (isBookmarked) {
        BookmarkManager.removeArticleIdFromBookmark(
          localUser.uid,
          widget.articleData.articleID,
        );
      } else {
        BookmarkManager.addArticleIdToBookmark(
          localUser.uid,
          widget.articleData.articleID,
        );
      }
      loadBookmarkState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loadBookmarkState() async {
    var currentTheme = ref.watch(themeProvider);
    try {
      if (supabase.auth.currentUser == null) return;
      if (mounted) {
        showProgressBar(context, currentTheme);
      }
      var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
        supabase.auth.currentUser!.id,
        widget.articleData.articleID,
      );
      var bookmarkCountData = await supabase
          .from('bookmarks')
          .select()
          .eq('article_id', widget.articleData.articleID)
          .count(CountOption.exact);
      if (mounted) {
        setState(() {
          isBookmarked = articleIsBookmarked;
          bookmarkCount = bookmarkCountData.count;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        closeProgressBar(context);
      }
    }
  }

  Widget displaySecondaryLabels() {
    var currentTheme = ref.watch(themeProvider);
    var trustLevelIconColor = getSuitableTrustIconColor(
      widget.articleData.articleTrustLevel,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: containerHorizontalLabelPadding,
      ),
      child: Row(
        spacing: 10,
        children: [
          ArticleLabel(
            content: getSuitableTextForTrustLevel(
              widget.articleData.articleTrustLevel,
            ),
            leadingIcon: Icon(
              Icons.circle,
              color: trustLevelIconColor,
              size: 14,
            ),
          ),
          ArticleLabel(
            content: widget.articleData.publisher,
            leadingIcon: Icon(
              Icons.newspaper,
              color: currentTheme.currentColorScheme.bgInverse,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  String getSuitableTextForTrustLevel(String trustLevel) {
    var localization = ref.watch(localizationProvider);
    switch (trustLevel.toLowerCase()) {
      case "high":
        return localization.highTrust;
      case "medium":
        return localization.mediumTrust;
      case "low":
        return localization.lowTrust;
      default:
        return localization.highTrust;
    }
  }

  Color getSuitableTrustIconColor(String trustLevel) {
    switch (trustLevel.toLowerCase()) {
      case "high":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  Widget displaySummaryText() {
    var currentTheme = ref.watch(themeProvider);
    var formattedSummaryText = formatSummaryText(
      widget.articleData.articleSummary,
    );
    return TextButton(
      onPressed: () {
        goToFullArticlePage();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: containerHorizontalLabelPadding,
        ),
        child: Text(
          formattedSummaryText,
          style: currentTheme.textTheme.bodySmall,
          textAlign: TextAlign.start,
          maxLines: cantLoadImage ? 6 : 2,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  Widget displayHyperlinkButtonOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [displayReadMoreButton(), displaySourceButton()],
      ),
    );
  }

  Widget displayReadMoreButton() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return TextButton(
      onPressed: () {
        goToFullArticlePage();
      },
      child: Text(
        localization.readMore,
        style: currentTheme.textTheme.smallLabelBold,
      ),
    );
  }

  void goToFullArticlePage() {
    var articleID = widget.articleData.articleID;
    Navigator.of(context).pushNamed("full_article/$articleID");
  }

  Widget displaySourceButton() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return TextButton(
      onPressed: () {
        showArticleSource();
      },
      child: Text(
        localization.sources,
        style: currentTheme.textTheme.smallLabelBold,
      ),
    );
  }

  void showArticleSource() {
    var currentTheme = ref.watch(themeProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              color: currentTheme.currentColorScheme.bgInverse,
              style: ButtonStyle(alignment: Alignment(-1.0, -1.0)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await launchUrl(Uri.parse(widget.articleData.source));
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: Icon(
                Icons.link,
                color: currentTheme.currentColorScheme.bgInverse,
              ),
            ),
          ],
        ),
        content: Text(
          widget.articleData.source,
          style: currentTheme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
