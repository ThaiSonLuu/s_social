import 'package:flutter/material.dart';

class STextField extends StatelessWidget {
  const STextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.enable = true,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String?>? validator;
  final int? minLines;
  final int? maxLines;
  final bool? enable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      minLines: minLines,
      maxLines: maxLines,
      enabled: enable,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
