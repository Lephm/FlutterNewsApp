import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/horizontal_divide_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelection extends ConsumerStatefulWidget {
  const CategorySelection({super.key, required this.category});

  final String category;

  @override
  ConsumerState<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends ConsumerState<CategorySelection> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    updateCheckboxValue();
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.currentColorScheme.bgPrimary,
      ),
      child: Column(
        children: [
          CheckboxListTile(
            title: Text(
              localization.getLocalLanguageLabelText(widget.category),
              style: currentTheme.textTheme.bodyMedium,
            ),
            value: _isChecked,
            onChanged: onCheckBoxChanged,
            fillColor: WidgetStatePropertyAll(
              currentTheme.currentColorScheme.bgPrimary,
            ),
            checkColor: currentTheme.currentColorScheme.bgInverse,
          ),
          HorizontalDivideLine(height: 0.5, horizontalMargin: 10),
        ],
      ),
    );
  }

  void onCheckBoxChanged(bool? newValue) {
    var queryCategoriesManager = ref.watch(queryCategoriesProvider.notifier);
    if (newValue == null) return;
    setState(() {
      _isChecked = newValue;
    });
    if (newValue) {
      queryCategoriesManager.addCategoryQuery(widget.category);
    } else {
      queryCategoriesManager.removeCategoryQuery(widget.category);
    }
  }

  void updateCheckboxValue() {
    var queryCategoriesList = ref.watch(queryCategoriesProvider);
    if (queryCategoriesList.contains(widget.category)) {
      setState(() {
        _isChecked = true;
      });
    } else {
      setState(() {
        _isChecked = false;
      });
    }
  }
}
