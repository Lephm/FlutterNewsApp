import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
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
  }) async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    try {
      final data = await queryArticles(startIndex, endIndex);
      if (data.isEmpty) {
        throw ArticleDataIsEmpty("There are no more articles");
      }

      for (var value in data) {
        state = [...state, ArticleData.fromJson(value)];
      }
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
  }) async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    try {
      final data = await queryArticles(startIndex, endIndex);
      state = [];
      for (var value in data) {
        state = [...state, ArticleData.fromJson(value)];
      }
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
    int endIndex,
  ) async {
    var queryParams = ref.watch(queryCategoriesProvider);
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
