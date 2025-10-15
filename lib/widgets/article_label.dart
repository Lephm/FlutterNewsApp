import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleLabel extends ConsumerWidget {
  const ArticleLabel({
    super.key,
    this.inversed = false,
    required this.content,
    this.leadingIcon,
  });

  final bool inversed;
  final String content;
  final Icon? leadingIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Placeholder();
  }
}
