import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/theme_provider.dart';
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
    List<String> queryParams = const [],
    required BuildContext context,
  }) async {
    var currentTheme = ref.watch(themeProvider);
    try {
      final data = await supabase
          .from('articles')
          .select()
          .contains('', queryParams);
      data.forEach((value) {
        state = [...state, ArticleData.fromJson(value)];
      });
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    }
  }

  Future<void> refereshArticlesData({
    List<String> queryParams = const [],
    required BuildContext context,
  }) async {
    var currentTheme = ref.watch(themeProvider);
    try {
      state = [];

      final data = await supabase
          .from('articles')
          .select()
          .contains('', queryParams);
      data.forEach((value) {
        state = [...state, ArticleData.fromJson(value)];
      });
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    }
  }
}
