import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/category_selection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 15),
        color: currentTheme.currentColorScheme.bgPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                titleText(),
                Flexible(child: clearFilterButton()),
              ],
            ),
            SizedBox(height: 30),
            Expanded(child: CategorySelectionContainer()),
          ],
        ),
      ),
    );
  }

  Widget clearFilterButton() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return TextButton(
      onPressed: clearFilter,
      child: Text(
        localization.clearFilter,
        style: currentTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  void clearFilter() {
    var queryCategoriesManager = ref.watch(queryCategoriesProvider.notifier);
    queryCategoriesManager.resetQueryParams();
  }

  Widget titleText() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: currentTheme.currentColorScheme.bgPrimary,
      ),
      child: Text(
        localization.category,
        style: currentTheme.textTheme.headlineMedium,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget horizontalDivideLine() {
    var currentTheme = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      color: currentTheme.currentColorScheme.bgInverse,
      width: double.infinity,
      height: 1,
    );
  }
}
