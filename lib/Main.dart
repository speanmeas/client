import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spean Meas Hotel',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple), //
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String VERSION = '0.0.0+0';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            SizedBox(width: 4), //
            // logo
            SizedBox(width: 32, height: 32, child: Placeholder()), //
            SizedBox(width: 4), //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Spean Meas Hotel"), //
                Text(VERSION, style: TextStyle(fontSize: 12, color: Colors.blue)), //
              ],
            ),
          ],
        ),
        titleSpacing: 0,
        toolbarHeight: 48,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text("Welcome"), //
          ],
        ),
      ),
    );
  }
}
