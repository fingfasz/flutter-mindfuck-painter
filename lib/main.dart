import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

bool? tokenExists;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tokenExists = await storage.containsKey(key: "token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfuck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: tokenExists! ? HomePage() : LoginPage(),
    );
  }
}
