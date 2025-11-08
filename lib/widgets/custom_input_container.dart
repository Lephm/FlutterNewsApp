import 'package:flutter/material.dart';

class CustomInputContainer extends StatelessWidget {
  const CustomInputContainer({
    super.key,
    this.child,
    this.backgroundColor,
    this.customBorder,
  });

  final Color? backgroundColor;
  final Widget? child;
  final Border? customBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: customBorder,
      ),
      child: child,
    );
  }
}
