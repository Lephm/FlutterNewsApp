import 'package:centranews/models/article_data.dart';

//TODO: this is a temporarily fix for duplicate article data
List<ArticleData> getUniqueArticleDatas(
  List<ArticleData> oldList,
  List<ArticleData> newDataList,
) {
  List<ArticleData> newArticleDatas = [];
  newArticleDatas = [...oldList];
  var oldArticleDataIds = oldList.map((articleData) => articleData.articleID);
  for (var data in newDataList) {
    if (!oldArticleDataIds.contains(data.articleID)) {
      newArticleDatas = [...newArticleDatas, data];
    }
  }
  return newArticleDatas;
}
