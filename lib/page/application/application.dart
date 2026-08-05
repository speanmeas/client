import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService.signout();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      return;
    }

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spean Meas Hotel'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "Welcome",
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
