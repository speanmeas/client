import 'package:flutter/material.dart';
import "package:speanmeas/features/auth/main.dart" as auth;
import "package:speanmeas/features/widget/widget.dart" as widget;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sign in'),
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

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();
  final node_username = FocusNode();
  final node_password = FocusNode();

  String username = '';
  String password = '';

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    node_username.dispose();
    node_password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await auth.AuthService.signin(
        username: username.trim(),
        password: password.trim(),
      );

      if (!mounted) return;

      debugPrint('Sign in success: $result');

      Navigator.of(context).pushReplacementNamed('/application');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyError(e))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    return msg.isEmpty ? 'Sign in failed. Please try again.' : msg;
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              widget.buildTextField(
                textInputAction: TextInputAction.next,
                label: 'Username',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your username';
                  }
                  return null;
                },
                focusNode: node_username,
                nextFocusNode: node_password,
              ),
              const SizedBox(height: 16),
              widget.buildTextField(
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                label: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
                focusNode: node_password,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/forgot-password'),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 8),
              widget.buildButton(
                label: 'Sign in',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/signup'),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
