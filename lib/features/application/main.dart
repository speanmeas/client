import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;

import '../auth/main.dart';

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Spean Meas Hotel'), //
      centerTitle: false,
      toolbarHeight: 48,
      titleSpacing: 0,
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

class _Main_State extends State<Main_> {
  ///
  /// Variables
  ///

  // Initialize
  void init() async {
    //
  }

  // View
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _layout([
      SizedBox(height: 20),
      Text(
        'Welcome to Spean Meas Hotel',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.primary),
      ),
      SizedBox(height: 20),
      OutlinedButton(
        child: Text('Sign Out'),
        onPressed: () => _signOut(context), //
      ),
    ]);
  }

  // Controller

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService.signout();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      return;
    }

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
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
