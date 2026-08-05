import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;

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
    return _layout([
      OutlinedButton(
        child: Text('Auth Telegram'),
        onPressed: () {}, //
      ),
    ]);
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
