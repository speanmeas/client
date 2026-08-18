import 'package:flutter/material.dart';

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Reset password'),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: const Divider(thickness: 1, color: Colors.black),
      ),
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: Column(children: children)),
          ),
        );
      },
    ),
  );
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  required TextInputAction textInputAction,
  String? Function(String?)? validator,
  FocusNode? focusNode,
  Icon? prefixIcon,
}) {
  return TextFormField(
    focusNode: focusNode,
    controller: controller,
    textInputAction: textInputAction,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: prefixIcon,
    ),
    validator: validator,
    onFieldSubmitted: (_) => FocusScope.of(focusNode!.context!).unfocus(),
  );
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();
  final c_phonenum = TextEditingController();
  final node_phonenum = FocusNode();

  bool _isLoading = false;
  bool _phonenumSent = false;

  @override
  void dispose() {
    c_phonenum.dispose();
    node_phonenum.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    debugPrint('Sending reset link to ${c_phonenum.text.trim()}');
    setState(() {
      _isLoading = false;
      _phonenumSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _phonenumSent ? _buildConfirmation() : _buildForm(),
      ),
    ]);
  }

  Widget _buildForm() {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Forgot your password?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter the phone number tied to your account and we'll send you a link to reset it.",
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: c_phonenum,
            focusNode: node_phonenum,
            textInputAction: TextInputAction.done,
            label: 'Phone number',
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your phone number';
              }

              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Send reset link'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 56,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        const Text(
          'Check your inbox',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'A reset link was sent to ${c_phonenum.text.trim()}.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/signin'),
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}
