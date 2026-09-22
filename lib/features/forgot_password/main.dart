import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import "package:speanmeas/features/widget/widget.dart" as widget;

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  final _formKey = GlobalKey<FormState>();

  final node_phone = FocusNode();

  String phone = '';

  bool _isLoading = false;
  bool _phoneSent = false;
  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
  @override
  Widget build(BuildContext context) {
    return widget.buildLayout(
      title: 'Reset password',
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: _phoneSent ? _buildConfirmation() : _buildForm(),
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
            focusNode: node_phone,
            textInputAction: TextInputAction.done,
            label: 'Phone number',
            prefixIcon: const Icon(Icons.phone_outlined),
            onChanged: (value) => setState(() => phone = value),
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
          'A reset link was sent to $phone.',
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
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  void on_forgot_password() async {
    if (_formKey.currentState!.validate()) {
      phone = phone.trim();
      setState(() {
        _isLoading = true;
      });

      try {
        debugPrint('Sending reset link to $phone');

        if (!mounted) return;

        setState(() {
          _phoneSent = true;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${_friendlyError(e)}')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String _friendlyError(Object e) {
    return e.toString();
  }

  void init() {
    //
  }

  @override
  void dispose() {
    node_phone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  // ########## BLOCK METHODS END ##########
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
