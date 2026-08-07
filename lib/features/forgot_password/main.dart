import 'package:flutter/material.dart';

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();
  final _phonenumController = TextEditingController();

  final bool _isLoading = false;
  final bool _phonenumSent = false;

  @override
  void dispose() {
    _phonenumController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print("Sending reset link to ${_phonenumController.text.trim()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _phonenumSent ? _buildConfirmation() : _buildForm(),
            ),
          ),
        ),
      ),
    );
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
          TextFormField(
            controller: _phonenumController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your phone number';
              }

              return null;
            },
            onFieldSubmitted: (_) => _submit(),
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
          'A reset link was sent to ${_phonenumController.text.trim()}.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}
