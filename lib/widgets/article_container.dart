import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:centranews/widgets/article_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

const double containerBorderRadius = 10;
const double containerHorizontalLabelPadding = 5;

class ArticleContainer extends ConsumerStatefulWidget {
  const ArticleContainer({super.key, required this.articleData});

  final ArticleData articleData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleContainer();
}

class _ArticleContainer extends ConsumerState<ArticleContainer> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
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

  Widget displayCategoriesLabels() {
    var localization = ref.watch(localizationProvider);
    var categoryContainers = <Widget>[];
    widget.articleData.categories.forEach((value) {
      categoryContainers.add(
        ArticleLabel(
          content: localization.getLocalLanguageLabelText(value),
          inversed: true,
        ),
      );
    });
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
            children: categoryContainers,
            spacing: 5,
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

    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.bookmarks_outlined,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
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
