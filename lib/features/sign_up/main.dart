import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Create an account'), //
      centerTitle: false,
      // toolbarHeight: 48,
      // titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Divider(thickness: 1, color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Column(
          children: children, //
        ),
      ),
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
  Widget? suffixIcon,
  FocusNode? nextFocusNode,
  bool obscureText = false,
  bool enable = true,
}) {
  return TextFormField(
    focusNode: focusNode,
    controller: controller,
    obscureText: obscureText,
    textInputAction: textInputAction,
    enabled: enable,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),
    validator: validator,
    onFieldSubmitted: (_) {
      if (nextFocusNode != null && focusNode?.context != null) {
        FocusScope.of(focusNode!.context!).requestFocus(nextFocusNode);
      }
    },
  );
}

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();

  final node_firstName = FocusNode();
  final node_lastName = FocusNode();
  final node_phone = FocusNode();
  final node_password = FocusNode();
  final node_confirm = FocusNode();

  final c_firstName = TextEditingController();
  final c_lastName = TextEditingController();
  final c_username = TextEditingController();
  final c_phone = TextEditingController();
  final c_password = TextEditingController();
  final c_confirm = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void dispose() {
    node_firstName.dispose();
    node_lastName.dispose();
    node_phone.dispose();
    node_password.dispose();
    node_confirm.dispose();
    c_firstName.dispose();
    c_lastName.dispose();
    c_username.dispose();
    c_phone.dispose();
    c_password.dispose();
    c_confirm.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Account created!')));

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
                'Please fill in your information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                focusNode: node_firstName,
                controller: c_firstName,
                textInputAction: TextInputAction.next,
                label: 'First name',
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your first name';
                  }
                  return null;
                },
                nextFocusNode: node_lastName,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_lastName,
                controller: c_lastName,
                textInputAction: TextInputAction.next,
                label: 'Last name',
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your last name';
                  }
                  return null;
                },
                nextFocusNode: node_phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: c_username,
                textInputAction: TextInputAction.next,
                label: 'Username',
                prefixIcon: Icon(Icons.person_outline),
                enable: false,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your first and last name above';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_phone,
                controller: c_phone,
                textInputAction: TextInputAction.next,
                label: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
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
              _buildTextField(
                focusNode: node_password,
                controller: c_password,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                label: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                nextFocusNode: node_confirm,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_confirm,
                controller: c_confirm,
                obscureText: true,
                textInputAction: TextInputAction.done,
                label: 'Confirm password',
                prefixIcon: Icon(Icons.lock_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != c_password.text) {
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
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/signin'),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void _loadUsername() {
    final generated =
        '${c_firstName.text.trim().toLowerCase()}${c_lastName.text.trim().toLowerCase()}'
            .trim();
    if (c_username.text != generated) {
      c_username.text = generated;
    }
  }

  @override
  void initState() {
    super.initState();
    c_firstName.addListener(_loadUsername);
    c_lastName.addListener(_loadUsername);
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
