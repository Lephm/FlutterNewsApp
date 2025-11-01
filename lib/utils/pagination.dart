import 'package:flutter/material.dart';

import '../models/custom_theme.dart';

mixin Pagination {
  static const double mainAxisExtendHeight = 400;
  final int _itemsPerPage = 15;
  int currentPage = 0;
  bool isLoading = false;
  final pageGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    crossAxisSpacing: 20,
    maxCrossAxisExtent: 600,
    mainAxisExtent: mainAxisExtendHeight,
    childAspectRatio: 1.0,
  );
  static const double almostTheEndOfPagePercent = 0.9;

  EdgeInsets pageEdgeInset = EdgeInsets.symmetric(horizontal: 40, vertical: 5);

  int get startIndex {
    return currentPage * _itemsPerPage;
  }

  int get endIndex {
    return startIndex + _itemsPerPage - 1;
  }

  void resetCurrentPage() {
    currentPage = 0;
  }

  void increaseCurrentPage() {
    currentPage += 1;
  }

  void decreaseCurrentPage() {
    if (currentPage > 0) {
      currentPage -= 1;
    }
  }

  Widget displayCircularProgressBar(CustomTheme currentTheme) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  bool isTheEndOfThePage(ScrollController scrollController) {
    return (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent *
                almostTheEndOfPagePercent &&
        !isLoading);
  }

  void scrollToTop(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
