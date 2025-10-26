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
}
