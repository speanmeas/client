import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import "package:speanmeas/features/widget/widget.dart" as widget;

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();

  final node_phonenum = FocusNode();

  String c_phonenum = '';

  bool _isLoading = false;
  bool _phonenumSent = false;

  void init() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildLayout(
      title: 'Reset password',
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: _phonenumSent ? _buildConfirmation() : _buildForm(),
        ),
      ],
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
          widget.buildTextField(
            focusNode: node_phonenum,
            textInputAction: TextInputAction.done,
            label: 'Phone number',
            prefixIcon: const Icon(Icons.phone_outlined),
            onChanged: (value) => setState(() => c_phonenum = value),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your phone number';
              }

              return null;
            },
          ),
          const SizedBox(height: 24),
          widget.buildButton(
            label: 'Send reset link',
            isLoading: _isLoading,
            onPressed: () {
              if (!_isLoading) on_forgot_password();
            },
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
          'A reset link was sent to $c_phonenum.',
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

  void on_forgot_password() async {
    if (_formKey.currentState!.validate()) {
      c_phonenum = c_phonenum.trim();
      setState(() {
        _isLoading = true;
      });

      try {
        debugPrint('Sending reset link to $c_phonenum');

        if (!mounted) return;

        setState(() {
          _phonenumSent = true;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${_friendlyError(e)}')));
      } finally {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _friendlyError(Object e) {
    return e.toString();
  }

  @override
  void dispose() {
    node_phonenum.dispose();
    super.dispose();
  }

  // Initialize the state
  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development",
      theme: theme.data(),
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
