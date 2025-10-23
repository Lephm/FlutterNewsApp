import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const FormAppBar({super.key, this.onBackButtonPressed});

  final void Function()? onBackButtonPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return AppBar(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      forceMaterialTransparency: true,
      leading: BackButton(
        onPressed: () {
          if (onBackButtonPressed == null) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          } else {
            onBackButtonPressed!();
          }
        },
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
