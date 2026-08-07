import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;

import '../auth/main.dart';

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();

  final _node_firstName = FocusNode();
  final _node_lastName = FocusNode();
  final _node_phone = FocusNode();
  final _node_password = FocusNode();
  final _node_confirm = FocusNode();

  final _c_firstName = TextEditingController();
  final _c_lastName = TextEditingController();
  final _c_phone = TextEditingController();
  final _c_password = TextEditingController();
  final _c_confirm = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _node_firstName.dispose();
    _node_lastName.dispose();
    _node_phone.dispose();
    _node_password.dispose();
    _node_confirm.dispose();
    _c_firstName.dispose();
    _c_lastName.dispose();
    _c_phone.dispose();
    _c_password.dispose();
    _c_confirm.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService.signup(
          username: _c_firstName.text.trim() + ' ' + _c_lastName.text.trim(),
          password: _c_password.text,
          fullName: _c_firstName.text.trim() + ' ' + _c_lastName.text.trim(),
          phoneNumber: _c_phone.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Account created!')));

        // Navigate to sign in (or home, if you auto-login)
        Navigator.of(context).pushReplacementNamed('/signin');
      } catch (e) {
        if (!mounted) return;
        setState(() {});
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _focusNextField(FocusNode nextFocusNode) {
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Please fill in your information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      focusNode: _node_firstName,
                      controller: _c_firstName,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'First name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _focusNextField(_node_lastName),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _node_lastName,
                      controller: _c_lastName,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Last name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _focusNextField(_node_phone),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _node_phone,
                      controller: _c_phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                        hintText: '0xxxxxxxx',
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';
                        if (phone.isEmpty) {
                          return 'Enter your phone number';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                          return 'Digits only';
                        }
                        if (phone.length < 8) {
                          return 'Must be at least 8 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _node_password,
                      controller: _c_password,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _focusNextField(_node_confirm),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _node_confirm,
                      controller: _c_confirm,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password';
                        }
                        if (value != _c_password.text) {
                          return 'Passwords do not match';
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
                          : const Text('Sign up'),
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
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed('/signin'),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
