import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8000", //
    ),
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post("/read")
        .then((response) {
          print(response.data);
        })
        .catchError((error) {
          print(error);
        });

    await dio
        .post(
          "/write",
          data: FormData.fromMap({
            "text_1": "Hello", //
            "text_2": "World",
            "number_1": 123,
            "number_2": 456,
          }),
        )
        .then((response) {
          print(response.data);
        })
        .catchError((error) {
          print(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"), //
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
