import 'package:flutter/material.dart';

import '../models/custom_theme.dart';

mixin Pagination {
  final int _itemsPerPage = 15;
  int currentPage = 0;
  bool isLoading = false;

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
    return (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading);
  }
}
