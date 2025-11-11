import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/article_data_retrieve_helper.dart';
import 'package:centranews/utils/custom_exception.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final mainArticlesProvider =
    NotifierProvider<MainArticlesNotifier, List<ArticleData>>(
      () => MainArticlesNotifier(),
    );

class MainArticlesNotifier extends Notifier<List<ArticleData>> {
  @override
  List<ArticleData> build() {
    return <ArticleData>[];
  }

  Future<void> fetchArticlesData({
    required BuildContext context,
    required int startIndex,
    required int endIndex,
    List<String> queryParams = const [],
  }) async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    try {
      final data = await queryArticles(
        startIndex,
        endIndex,
        queryParams: queryParams,
      );
      if (data.isEmpty) {
        throw ArticleDataIsEmpty("There are no more articles");
      }
      List<ArticleData> newArticleData = [];
      for (var value in data) {
        newArticleData = [...newArticleData, ArticleData.fromJson(value)];
      }
      state = getUniqueArticleDatas(state, newArticleData);
    } on ArticleDataIsEmpty catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(
          context,
          localization.errorLoadingArticles,
          currentTheme,
        );
      }
    }
  }

  Future<void> refereshArticlesData({
    required BuildContext context,
    required int startIndex,
    required int endIndex,
    List<String> queryParams = const [],
  }) async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    try {
      final data = await queryArticles(
        startIndex,
        endIndex,
        queryParams: queryParams,
      );
      state = [];
      List<ArticleData> firstTimeLoadingArticlesList = [];
      for (var value in data) {
        firstTimeLoadingArticlesList = [
          ...firstTimeLoadingArticlesList,
          ArticleData.fromJson(value),
        ];
      }
      firstTimeLoadingArticlesList.shuffle();
      List<ArticleData> randomizedArticleList = [
        ...firstTimeLoadingArticlesList,
      ];
      state = randomizedArticleList;
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(
          context,
          localization.errorLoadingArticles,
          currentTheme,
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> queryArticles(
    int startIndex,
    int endIndex, {
    List<String> queryParams = const [],
  }) async {
    if (queryParams.isEmpty) {
      return supabase
          .from('articles')
          .select()
          .order('created_at', ascending: false)
          .range(startIndex, endIndex);
    }
    return supabase
        .from('articles')
        .select()
        .contains('categories', queryParams)
        .order('created_at', ascending: false)
        .range(startIndex, endIndex);
  }
}
