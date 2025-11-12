import 'package:centranews/models/article_data.dart';
//import 'package:flutter/material.dart';

// TODO: this is just to make there are no duplicate article data, currently disabling this to improve performance
List<ArticleData> getUniqueArticleDatas(
  List<ArticleData> oldList,
  List<ArticleData> newDataList,
) {
  /*List<ArticleData> newArticleDatas = [];
  newArticleDatas = [...oldList];
  var oldArticleDataIds = oldList.map((articleData) => articleData.articleID);
  for (var data in newDataList) {
    if (!oldArticleDataIds.contains(data.articleID)) {
      newArticleDatas = [...newArticleDatas, data];
    } else {
      debugPrint("Has removed one article to prevent duplication");
    }
  }*/
  List<ArticleData> newArticleDatas = [...oldList, ...newDataList];
  return newArticleDatas;
}
