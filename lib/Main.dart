import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'page/application/application.dart';
import 'page/forgot_password/forgot_password.dart';
import 'page/sign_in/signin.dart';
import 'page/sign_up/signup.dart';

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
      routes: {
        _Routes.signUp: (context) => const SignUp(),
        _Routes.signIn: (context) => const SignIn(),
        _Routes.forgotPassword: (context) => const ForgotPassword(),
        _Routes.application: (context) => const Application(),
      },
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
                Text(
                  VERSION,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ), //
              ],
            ),
          ],
        ),
        titleSpacing: 0,
        toolbarHeight: 48,
      ),
      // *For previewing the pages
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            _buildSideItem(
              context,
              'Sign Up',
              Icons.person_add_outlined,
              '/signup',
            ),
            _buildSideItem(context, 'Sign In', Icons.login, '/signin'),
            _buildSideItem(
              context,
              'Forgot Password',
              Icons.lock_reset_outlined,
              '/forgot-password',
            ),
            _buildSideItem(
              context,
              'Main Application',
              Icons.dashboard_outlined,
              '/application',
            ),
          ],
        ),
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

class _Routes {
  static const signUp = '/signup';
  static const signIn = '/signin';
  static const forgotPassword = '/forgot-password';
  static const application = '/application';
}

Widget _buildSideItem(
  BuildContext context,
  String title,
  IconData icon,
  String route,
) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () => Navigator.pushNamed(context, route),
  );
}
