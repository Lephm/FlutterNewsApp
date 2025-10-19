import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/bookmark_manager.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:centranews/widgets/article_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const double containerBorderRadius = 10;
const double containerHorizontalLabelPadding = 5;
final supabase = Supabase.instance.client;

class ArticleContainer extends ConsumerStatefulWidget {
  const ArticleContainer({super.key, required this.articleData});

  final ArticleData articleData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleContainer();
}

class _ArticleContainer extends ConsumerState<ArticleContainer> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      if (supabase.auth.currentUser != null) {
        loadBookmarkStateStartUp(supabase.auth.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localUser = ref.watch(userProvider);
    if (localUser != null) {
      loadBookmarkStateStartUp(localUser.uid);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: currentTheme.currentColorScheme.bgPrimary,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(5, 3),
            color: currentTheme.currentColorScheme.bgInverse.withAlpha(100),
          ),
        ],
      ),
      width: double.infinity,
      height: 300,
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
    for (var categorie in widget.articleData.categories) {
      categoryContainers.add(
        ArticleLabel(
          content: localization.getLocalLanguageLabelText(categorie),
          inversed: true,
        ),
      );
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
      flex: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        child: Image.network(
          widget.articleData.thumbnailUrl,
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
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
        displayShareAndBookmarkButton(),
      ],
    );
  }

  Widget displayShareAndBookmarkButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [shareButton(), SizedBox(width: 10), bookmarkButton()],
      ),
    );
  }

  Widget shareButton() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return IconButton(
      onPressed: () async {
        final articleId = widget.articleData.articleID;
        final linkToCopied =
            "${CustomNavigatorSettings.domainName}/#/full_article/$articleId";
        await Clipboard.setData(ClipboardData(text: linkToCopied));

        if (context.mounted) {
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

  void loadBookmarkStateStartUp(String userId) async {
    var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
      userId,
      widget.articleData.articleID,
    );
    if (mounted) {
      setState(() {
        isBookmarked = articleIsBookmarked;
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
        setState(() {
          isBookmarked = false;
        });
      } else {
        BookmarkManager.addArticleIdToBookmark(
          localUser.uid,
          widget.articleData.articleID,
        );
        setState(() {
          isBookmarked = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget displaySecondaryLabels() {
    var trustLevelIconColor = getSuitableTrustIconColor(
      widget.articleData.articleTrustLevel,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: containerHorizontalLabelPadding,
      ),
      child: Row(
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
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: containerHorizontalLabelPadding,
      ),
      child: Text(
        widget.articleData.articleSummary,
        style: currentTheme.textTheme.bodySmall,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.fade,
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
    var articleID = widget.articleData.articleID;
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed("full_article/$articleID");
      },
      child: Text(
        localization.readMore,
        style: currentTheme.textTheme.smallLabelBold,
      ),
    );
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
            BackButton(style: ButtonStyle(alignment: Alignment(-1.0, -1.0))),
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
