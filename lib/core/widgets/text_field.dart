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
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String?>? validator;

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
      obscureText: obscureText,
      validator: validator,
    );
  }
}
