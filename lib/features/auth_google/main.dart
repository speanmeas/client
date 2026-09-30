import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import 'package:speanmeas/core/utility/dio.dart';
import 'package:dio/dio.dart';
import 'package:speanmeas/features/application/main.dart' as app;

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
  String? googleToken;
  bool isLoading = false;
  String? errorMessage;

  // Initialize
  void init() {
    final uri = Uri.base;
    final token = uri.queryParameters['token'] ??
        uri.queryParameters['access_token'] ??
        uri.queryParameters['user_id'];
    if (token != null) {
      setState(() {
        googleToken = token;
        isLoading = true;
        errorMessage = null;
      });
      on_google_token_received(token);
    }
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _layout([
      if (isLoading) ...[
        SizedBox(height: 20),
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text('Logging in with Google...'),
      ],
      if (errorMessage != null) ...[
        SizedBox(height: 20),
        Text(errorMessage!, style: TextStyle(color: Colors.red)),
        SizedBox(height: 20),
      ],
      OutlinedButton(
        child: Text('Auth Google'),
        onPressed: () async {
          try {
            final url = Uri.parse('https://trychansak.1riel.com/google_auth');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          } catch (e) {
            print(e);
          }
        }, //
      ),
    ]);
  }

  void on_google_token_received(String token) async {
    try {
      var tmp = await dio.get(
        '/google_auth',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint(tmp.toString());

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => app.Main_()),
      );
    } catch (e) {
      debugPrint("Google sign in failed: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Google sign in failed';
      });
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
