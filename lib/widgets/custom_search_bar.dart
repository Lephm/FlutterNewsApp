import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  const CustomSearchBar({super.key, this.arg, this.onSubmittedSearched});

  final String? arg;
  final void Function(String value)? onSubmittedSearched;

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends ConsumerState<CustomSearchBar> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return SizedBox(
      height: 30,
      child: SearchBar(
        elevation: WidgetStatePropertyAll(0),
        hintStyle: WidgetStatePropertyAll(
          currentTheme.textTheme.bodyLightMedium,
        ),
        textStyle: WidgetStatePropertyAll(currentTheme.textTheme.bodyMedium),
        hintText: localization.search,
        backgroundColor: WidgetStatePropertyAll(
          currentTheme.currentColorScheme.bgPrimary,
        ),
        trailing: [
          Icon(Icons.search, color: currentTheme.currentColorScheme.bgInverse),
        ],
        controller: searchController,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onSubmitted: (value) {
          widget.onSubmittedSearched!(value);
        },
      ),
    );
  }
}
