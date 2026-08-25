import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speanmeas/core/theme/theme_data.dart' as theme;
import 'package:speanmeas/core/utility/dio.dart';
import 'package:dio/dio.dart';
import 'package:speanmeas/features/application/main.dart' as app;
import 'package:speanmeas/core/endpoint.g.dart' as ep;

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
  String? telegramToken;
  bool isLoading = false;
  String? errorMessage;

  // Initialize
  void init() {
    final token = Uri.base.queryParameters['token'];
    if (token != null) {
      setState(() {
        telegramToken = token;
        isLoading = true;
        errorMessage = null;
      });
      on_telegram_token_received(token);
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
        Text('Logging in with Telegram...'),
      ],
      if (errorMessage != null) ...[
        SizedBox(height: 20),
        Text(errorMessage!, style: TextStyle(color: Colors.red)),
        SizedBox(height: 20),
      ],
      OutlinedButton(
        child: Text('Auth Telegram'),
        onPressed: () async {
          try {
            final url = Uri.parse(
              'https://trychansak.1riel.com/auth_client/trychansak/telegram_auth',
            );
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

  void on_telegram_token_received(String token) async {
    try {
      var tmp = await dio.get(
        ep.endpoint.AUTH_CLIENT_TRYCHANSAK_TELEGRAM,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint(tmp.toString());

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => app.Main_()),
      );
    } catch (e) {
      debugPrint("Telegram sign in failed: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Telegram sign in failed';
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
