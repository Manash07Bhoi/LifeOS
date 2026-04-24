import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int maxLength;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength = 255,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
