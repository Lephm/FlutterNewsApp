mixin Pagination {
  final int _itemsPerPage = 10;
  int currentPage = 0;

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
}
