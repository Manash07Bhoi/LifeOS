import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final bool glow;

  const NeonText(
    this.text, {
    super.key,
    required this.color,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.glow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: glow
            ? [
                Shadow(color: color.withValues(alpha: 0.6), blurRadius: 10.0),
                Shadow(color: color.withValues(alpha: 0.3), blurRadius: 20.0),
              ]
            : null,
      ),
    );
  }
}
