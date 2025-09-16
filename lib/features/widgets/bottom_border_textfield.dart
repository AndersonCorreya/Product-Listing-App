import 'package:flutter/material.dart';

class BottomBorderTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final double? width;
  const BottomBorderTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
    this.focusNode,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        obscureText: obscureText,
        enabled: enabled,
        maxLines: maxLines,
        validator: validator,
        focusNode: focusNode,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 0,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2.0),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
