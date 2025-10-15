import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/article_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

const double containerBorderRadius = 10;
const double containerHorizontalLabelPadding = 5;
//TODO Implement base url
String baseDomainUrl = "Domain Base Url";

class ArticleContainer extends ConsumerStatefulWidget {
  const ArticleContainer({super.key, required this.articleData});

  final ArticleData articleData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleContainer();
}

class _ArticleContainer extends ConsumerState<ArticleContainer> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      baseDomainUrl = Uri.base.origin;
    }
  }

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
      width: 600,
      height: 300,

      child: Column(
        children: [displayThumbnail(), displayPublishedDate(), displayTitle()],
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
        vertical: 10,
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
    var currentTheme = ref.watch(themeProvider);
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: currentTheme.currentColorScheme.bgInverse,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.bookmarks_outlined,
              color: currentTheme.currentColorScheme.bgInverse,
            ),
          ),
        ],
      ),
    );
  }

  Widget displaySecondaryLabel() {
    return ArticleLabel(content: "");
  }
}
