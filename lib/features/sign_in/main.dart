import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import "package:speanmeas/features/auth/main.dart" as auth;
import "package:speanmeas/features/widget/widget.dart" as widget;

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  final _formKey = GlobalKey<FormState>();

  final node_identifier = FocusNode();
  final node_password = FocusNode();

  String identifier = '';
  String password = '';

  bool _obscurePassword = true;
  bool _isLoading = false;
  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
  @override
  Widget build(BuildContext context) {
    return widget.buildLayout(
      title: 'Sign in',
      children: [
        Form(
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
                label: 'Username or phone number',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your username or phone number';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => identifier = value),
                focusNode: node_identifier,
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
                onChanged: (value) => setState(() => password = value),
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
                onPressed: () {
                  if (!_isLoading) on_sign_in();
                },
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
      ],
    );
  }
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  void on_sign_in() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await auth.AuthService.signin(
          username: identifier.trim(),
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    return msg.isEmpty ? 'Sign in failed. Please try again.' : msg;
  }

  void init() {
    //
  }

  @override
  void dispose() {
    node_identifier.dispose();
    node_password.dispose();
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