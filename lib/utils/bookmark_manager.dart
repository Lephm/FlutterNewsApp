import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class BookmarkManager {
  static Future<bool> isArticleBookmarked(
    String userId,
    String articleId,
  ) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }
    try {
      var data = await supabase
          .from('bookmarks')
          .select()
          .eq('user_id', userId)
          .contains('article_ids', [articleId]);
      return data.isEmpty ? false : true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<void> addArticleIdToBookmark(String articleId) async {}

  static Future<void> removeArticleIdFromBookmark(String articleId) async {}

  static Future<void> getBookmarkArticles() async {}
}
