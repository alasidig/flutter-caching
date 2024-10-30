
import 'package:flutter/material.dart';

class TextBoxWithBackground extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const TextBoxWithBackground({
    super.key, required this.text, required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ));
  }
}

