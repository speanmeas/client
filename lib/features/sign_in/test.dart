import 'package:flutter/material.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import 'package:speanmeas/core/utility/dio.dart';
import 'package:speanmeas/features/application/main.dart' as app;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Spean Meas Hotel'), //
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

class _Main_State extends State<Main_> {
  ///

  final c_username = TextEditingController();
  final c_password = TextEditingController();

  // Initialize
  void init() async {
    //
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _layout([
      TextField(
        controller: c_username, //
      ),

      TextField(
        controller: c_password, //
      ),

      OutlinedButton(
        child: Text('Sign In'), //
        onPressed: on_sign_in, //
      ),
    ]);
  }

  void on_sign_in() async {
    try {
      //
      final username = c_username.text.trim();
      final password = c_password.text.trim();

      var tmp = await dio.post(
        '/auth/sign_in',
        data: {
          'username': username, //
          'password': password,
        },
      );

      print(tmp);

      Navigator.push(context, MaterialPageRoute(builder: (context) => app.Main_()));
    } catch (e) {
      print("Sign in failed");
    }
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
