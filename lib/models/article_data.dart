class ArticleData {
  static String parseDateToString(String dateObj) {
    var dateTime = DateTime.tryParse(dateObj);
    if (dateTime == null) {
      return "N/A";
    }
    return dateTime
        .toString()
        .split(" ")[0]
        .toString()
        .split('-')
        .reversed
        .join('-');
  }

  ArticleData({
    required this.articleID,
    required this.articleTitle,
    required this.articleSummary,
    required this.categories,
    required this.articleContent,
    required this.articleTrustLevel,
    required this.thumbnailUrl,
    required this.date,
    required this.source,
  });

  ArticleData.fromJson(Map<String, dynamic> json)
    : articleID = json["article_id"].toString(),
      articleTitle = json["title"].toString(),
      articleSummary = json["summary"] as String,
      categories = json["categories"].cast<String>(),
      articleContent = json["content"].toString(),
      articleTrustLevel = json["trust_level"].toString(),
      thumbnailUrl = json["thumbnail_url"].toString(),
      date = parseDateToString(json["published_at"].toString()),
      source = json["source"]?.toString() ?? "N/A";

  final String articleID;
  final String articleTitle;
  final String articleSummary;
  final List<String> categories;
  final String articleContent;
  final String articleTrustLevel;
  final String thumbnailUrl;
  final String source;
  String date;

  @override
  String toString() {
    Map<String, String> printData = {
      "articleID": articleID,
      "articleTitle": articleTitle,
      "article Summary": articleSummary,
      "categories": categories.toString(),
      "articleContent": articleContent,
      "articleTrustLevel": articleTrustLevel,
      "thumbnail_url": thumbnailUrl,
      "date": date,
    };
    return printData.toString();
  }
}
