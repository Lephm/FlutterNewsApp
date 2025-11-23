import 'package:centranews/models/article_data.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class BookmarkManager {
  static Future<bool> isArticleBookmarked(String articleId) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }
    try {
      var data = await supabase
          .from('bookmarks')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('article_id', articleId);
      return data.isEmpty ? false : true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<void> addArticleIdToBookmark(
    String userId,
    String articleId,
  ) async {
    try {
      await supabase.from('bookmarks').insert({
        'user_id': userId,
        'article_id': articleId,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> removeArticleIdFromBookmark(
    String userId,
    String articleId,
  ) async {
    try {
      await supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('article_id', articleId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<ArticleData>> getBookmarkArticles(
    int startIndex,
    int endIndex,
  ) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }
    List<String> articleIdList = [];
    var articleIdDatas = await supabase
        .from('bookmarks')
        .select()
        .eq("user_id", supabase.auth.currentUser!.id)
        .range(startIndex, endIndex);
    for (var articleIdData in articleIdDatas) {
      if (articleIdData["article_id"] != null) {
        articleIdList.add(articleIdData["article_id"]);
      }
    }
    var data = await supabase
        .from('articles')
        .select()
        .inFilter("article_id", articleIdList)
        .order('created_at', ascending: false)
        .order('article_id', ascending: true);
    List<ArticleData> bookmarkArticles = [];
    for (var article in data) {
      bookmarkArticles.add(ArticleData.fromJson(article));
    }
    return bookmarkArticles;
  }
}
