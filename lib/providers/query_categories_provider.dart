import 'package:flutter_riverpod/flutter_riverpod.dart';

final queryCategoriesProvider =
    NotifierProvider<QueryCategoriesNotifier, List<String>>(
      () => QueryCategoriesNotifier(),
    );

class QueryCategoriesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return <String>[];
  }

  void resetQueryParams() {
    state = [];
  }

  void addCategoryQuery(String category) {
    if (state.contains(category)) {
      return;
    }
    state = [...state, category];
  }

  void removeCategoryQuery(String category) {
    var newCategoryQueryList = state;
    if (state.contains(category)) {
      newCategoryQueryList.remove(category);
      state = [...newCategoryQueryList];
    }
  }

  void resetCategoryQuery() {
    state = [];
  }
}
