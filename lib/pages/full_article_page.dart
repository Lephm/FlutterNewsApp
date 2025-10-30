import 'package:centranews/models/article_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_safe_area.dart';

final supabase = Supabase.instance.client;
const double thumbnailImageHeight = 300;

class FullArticlePage extends ConsumerStatefulWidget {
  const FullArticlePage({super.key, this.arg});

  final String? arg;

  @override
  ConsumerState<FullArticlePage> createState() => _FullArticlePageState();
}

class _FullArticlePageState extends ConsumerState<FullArticlePage> {
  String articleID = "";
  bool _isLoading = true;
  ArticleData? articleData;

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
            onPressed: () {
              Navigator.of(context).pushNamed("/");
            },
          ),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: _isLoading
            ? displayCircularProgressBar()
            : ((articleData == null) ? renderErrorPage() : renderArticle()),
      ),
    );
  }

  Widget renderErrorPage() {
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

  Widget renderArticle() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            spacing: 10,
            children: [
              Text(
                articleData!.articleTitle,
                style: currentTheme.textTheme.headlineMedium,
              ),

              Image.network(
                articleData!.thumbnailUrl,
                errorBuilder: (context, error, stackTrace) =>
                    displayThumbnailErrorWidget(),
                width: double.infinity,
                height: thumbnailImageHeight,
                fit: BoxFit.cover,
              ),
              Text(
                articleData!.articleSummary,
                style: currentTheme.textTheme.bodySmall,
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
      ),
    );
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
          .select()
          .eq("article_id", articleID)
          .single();
      setState(() {
        articleData = ArticleData.fromJson(data);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showErrorMessage() {}

  Widget displayThumbnailErrorWidget() {
    var currentTheme = ref.watch(themeProvider);
    return SizedBox(
      width: double.infinity,
      height: thumbnailImageHeight,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
      ),
    );
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
              style: currentTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
