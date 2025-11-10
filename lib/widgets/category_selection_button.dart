import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CategorySelectionButton extends ConsumerStatefulWidget {
  const CategorySelectionButton({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  final String category;
  final bool isSelected;

  @override
  ConsumerState<CategorySelectionButton> createState() =>
      _CategorySelectionButtonState();
}

class _CategorySelectionButtonState
    extends ConsumerState<CategorySelectionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var displayText = localization.getLocalLanguageLabelText(widget.category);
    return ScaleTransition(
      scale: scaleAnimation,
      child: IntrinsicWidth(
        child: FittedBox(
          fit: BoxFit.fill,
          child: TextButton(
            onPressed: () {
              animationController.forward();
              toggleQueryParam();
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                Container(
                  width: 120,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                  decoration: BoxDecoration(
                    color: currentTheme.currentColorScheme.bgInverse,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Text(
                          displayText,
                          style: currentTheme.textTheme.categoryTextBoldInverse,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                        (widget.isSelected
                            ? Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.backspace,
                                    color: currentTheme
                                        .currentColorScheme
                                        .bgPrimary,
                                    size: 10,
                                  ),
                                ],
                              )
                            : SizedBox.shrink()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleQueryParam() {
    var queryCategoriesManager = ref.watch(queryCategoriesProvider.notifier);
    if (!widget.isSelected) {
      queryCategoriesManager.addCategoryQuery(widget.category);
      addCategoryToUserPref();
    } else {
      queryCategoriesManager.removeCategoryQuery(widget.category);
      removeCategoryToUserPref();
    }
  }

  Future<void> addCategoryToUserPref() async {
    if (supabase.auth.currentUser == null) return;
    try {
      await supabase.from('user_prefered_category').insert({
        'user_id': supabase.auth.currentUser!.id,
        'category': widget.category,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeCategoryToUserPref() async {
    if (supabase.auth.currentUser == null) return;
    try {
      await supabase
          .from('user_prefered_category')
          .delete()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('category', widget.category);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
