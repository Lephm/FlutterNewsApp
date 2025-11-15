import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/categories_list.dart';
import 'package:centranews/widgets/category_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CategorySelectionContainer extends ConsumerStatefulWidget {
  const CategorySelectionContainer({super.key});

  @override
  ConsumerState<CategorySelectionContainer> createState() =>
      _CategorySelectionContainerState();
}

class _CategorySelectionContainerState
    extends ConsumerState<CategorySelectionContainer> {
  var scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var queryParams = ref.watch(queryCategoriesProvider);
    List<String> unselectedQueries = categories
        .where((element) => !queryParams.contains(element))
        .toList();
    List<String> selectedQueries = categories
        .where((element) => queryParams.contains(element))
        .toList();
    List<Widget> unselectedWidget = [];
    List<Widget> selectedWidget = [];
    for (var query in unselectedQueries) {
      unselectedWidget.add(
        CategorySelectionButton(category: query, key: ValueKey(query)),
      );
    }
    for (var query in selectedQueries) {
      selectedWidget.add(
        CategorySelectionButton(
          category: query,
          isSelected: true,
          key: ValueKey(query),
        ),
      );
    }

    return Container(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            displayCategoriesSelectionButton(
              selectedWidget,
              Icon(
                Icons.filter_alt,
                color: currentTheme.currentColorScheme.bgInverse,
              ),
            ),
            displayCategoriesSelectionButton(
              unselectedWidget,
              Icon(
                Icons.category,
                color: currentTheme.currentColorScheme.bgInverse,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayCategoriesSelectionButton(
    List<Widget> categorSelectionWidgets,
    Widget leadingIcon,
  ) {
    if (categorSelectionWidgets.isEmpty) return SizedBox.shrink();
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(fit: BoxFit.cover, child: categorizedWidget(leadingIcon)),
            Wrap(spacing: 4, runSpacing: 0, children: categorSelectionWidgets),
          ],
        ),
      ),
    );
  }

  Widget categorizedWidget(Widget leadingWidget) {
    var currentTheme = ref.watch(themeProvider);
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          leadingWidget,
          Text(":", style: currentTheme.textTheme.bodyMedium),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
