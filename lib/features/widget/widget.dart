import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField({
  required String label,
  required TextInputAction textInputAction,
  ValueChanged<String>? onChanged,
  Key? fieldKey,
  String? initialValue,
  String? Function(String?)? validator,
  FocusNode? focusNode,
  Icon? prefixIcon,
  Widget? suffixIcon,
  FocusNode? nextFocusNode,
  bool obscureText = false,
  bool enable = true,
  List<TextInputFormatter>? inputFormatters,
  String? helperText,
}) {
  return TextFormField(
    key: fieldKey,
    focusNode: focusNode,
    initialValue: initialValue,
    obscureText: obscureText,
    textInputAction: textInputAction,
    enabled: enable,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      labelText: label,
      helperText: helperText,
      border: OutlineInputBorder(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),
    validator: validator,
    onChanged: onChanged,
    onFieldSubmitted: (_) {
      if (nextFocusNode != null && focusNode?.context != null) {
        FocusScope.of(focusNode!.context!).requestFocus(nextFocusNode);
      }
    },
  );
}
