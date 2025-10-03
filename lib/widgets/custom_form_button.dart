import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_input_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomFormButton extends ConsumerWidget {
  const CustomFormButton({super.key, this.onPressed, this.content = ""});
  final void Function()? onPressed;
  final String content;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return CustomInputContainer(
      backgroundColor: currentTheme.currentColorScheme.bgInverse,

      child: TextButton(
        onPressed: onPressed,
        child: Text(content, style: currentTheme.textTheme.bodyInverseMedium),
      ),
    );
  }
}
