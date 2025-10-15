import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double containerBorderRadius = 10;

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
      width: 600,
      height: 300,

      child: Column(
        children: [
          Flexible(
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
          ),
        ],
      ),
    );
  }
}
