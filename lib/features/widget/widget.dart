import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildLayout({required String title, required List<Widget> children}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: const Divider(thickness: 1, color: Colors.black),
      ),
    ),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget buildButton({
  required String label,
  required VoidCallback onPressed,
  bool isLoading = false,
  Color? color,
  Color? textColor,
}) {
  return FilledButton(
    onPressed: isLoading ? null : onPressed,
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label, style: const TextStyle(fontSize: 16)),
  );
}

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
