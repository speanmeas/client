import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  Future<void> _signOut(BuildContext context) async {
    if (!context.mounted) return;
    // TODO: Make sure it goes back to sign page
    Navigator.of(context).popUntil((route) => route.isFirst);
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
