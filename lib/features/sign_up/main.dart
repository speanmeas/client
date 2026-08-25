import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speanmeas/core/endpoint.g.dart' as ep;
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import 'package:speanmeas/core/utility/dio.dart';
import 'package:speanmeas/features/sign_in/main.dart' as signin;

class _UsernameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_]'),
      '',
    );
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Create an account'), //
      centerTitle: false,
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
  required TextInputAction textInputAction,
  required ValueChanged<String> onChanged,
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
      border: const OutlineInputBorder(),
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

class _Main_State extends State<Main_> {
  final _formKey = GlobalKey<FormState>();

  final node_firstName = FocusNode();
  final node_lastName = FocusNode();
  final node_username = FocusNode();
  final node_phone = FocusNode();
  final node_password = FocusNode();
  final node_confirm = FocusNode();

  String? firstName;
  String? lastName;
  String? username;
  String? phone;
  String? password;
  String? confirmPassword;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _usernameManuallyEdited = false;

  String get _suggestedUsername {
    final first = (firstName ?? '').trim().toLowerCase().replaceAll("'", '_');
    final last = (lastName ?? '').trim().toLowerCase().replaceAll("'", '_');
    return '$first$last';
  }

  void init() {
    //
  }

  void _onNameChanged() {
    if (_usernameManuallyEdited) return;
    username = _suggestedUsername;
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
                initialValue: firstName,
                textInputAction: TextInputAction.next,
                label: 'First name',
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) {
                    return 'Enter your first name';
                  }
                  if (!RegExp(r"^[A-Za-z']+$").hasMatch(name)) {
                    return 'Letters only';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                    _onNameChanged();
                  });
                },
                nextFocusNode: node_lastName,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_lastName,
                initialValue: lastName,
                textInputAction: TextInputAction.next,
                label: 'Last name',
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) {
                    return 'Enter your last name';
                  }
                  if (!RegExp(r"^[A-Za-z']+$").hasMatch(name)) {
                    return 'Letters only';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                    _onNameChanged();
                  });
                },
                nextFocusNode: node_username,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                fieldKey: ValueKey(
                  _usernameManuallyEdited ? 'username-manual' : username,
                ),
                focusNode: node_username,
                initialValue: username,
                textInputAction: TextInputAction.next,
                label: 'Username',
                prefixIcon: Icon(Icons.person_outline),
                inputFormatters: [_UsernameInputFormatter()],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a username';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    username = value;
                    _usernameManuallyEdited = true;
                  });
                },
                nextFocusNode: node_phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_phone,
                initialValue: phone,
                textInputAction: TextInputAction.next,
                label: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
                validator: (value) {
                  final p = value?.trim() ?? '';
                  if (p.isEmpty) {
                    return 'Enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(p)) {
                    return 'Digits only';
                  }
                  if (p.length < 8) {
                    return 'Must be at least 8 digits';
                  }
                  if (!p.startsWith('0')) {
                    return 'Must start with 0';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => phone = value),
                nextFocusNode: node_password,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_password,
                initialValue: password,
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
                onChanged: (value) => setState(() => password = value),
                nextFocusNode: node_confirm,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                focusNode: node_confirm,
                initialValue: confirmPassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                label: 'Confirm password',
                prefixIcon: Icon(Icons.lock_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => confirmPassword = value),
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : on_sign_up,
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

  void on_sign_up() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await dio.post(
          ep.AUTH_CLIENT_KHUNBUNHAP_SIGN_UP,
          data: {
            'username': (username ?? '').trim(),
            'password': (password ?? '').trim(),
            'full_name':
                '${(firstName ?? '').trim()} ${(lastName ?? '').trim()}',
            'phone_number': (phone ?? '').trim(),
          },
        );

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => signin.Main_()),
        );
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
    if (e is DioException) {
      final data = e.response?.data;
      if (data is String && data.trim().isNotEmpty) return data;
      if (data is Map && data['detail'] != null)
        return data['detail'].toString();
    }
    return e.toString();
  }

  @override
  void dispose() {
    node_firstName.dispose();
    node_lastName.dispose();
    node_username.dispose();
    node_phone.dispose();
    node_password.dispose();
    node_confirm.dispose();
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
