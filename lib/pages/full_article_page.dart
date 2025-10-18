import 'package:centranews/models/article_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_safe_area.dart';

final supabase = Supabase.instance.client;

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

  //TODO implement this
  Widget renderErrorPage() {
    return Placeholder();
  }

  Widget renderArticle() {
    var currentTheme = ref.watch(themeProvider);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          children: [
            Text(
              articleData!.articleTitle,
              style: currentTheme.textTheme.headlineMedium,
            ),
            Text(
              articleData!.articleSummary,
              style: currentTheme.textTheme.bodySmall,
            ),
            Image.network(
              articleData!.thumbnailUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            Text(
              articleData!.articleContent,
              style: currentTheme.textTheme.bodySmall,
            ),
            displayGoToSourceButton(),
          ],
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
