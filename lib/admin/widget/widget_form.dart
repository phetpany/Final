import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.label,
    this.validator,
    this.controller,
    this.keyboardType,
    this.maxLines = 1, // Default to 1 line to avoid multiline password issues
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  final Widget? label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines; // Ensure this is an int, not nullable
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: obscureText ? 1 : maxLines, // Ensure password is single line
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: Colors.grey.shade300,
        filled: true,
        border: InputBorder.none,
        label: label,
      ),
    );
  }
}
