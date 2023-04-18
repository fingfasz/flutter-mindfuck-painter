import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: prefer_const_constructors
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
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          //colorSchemeSeed: Colors.purple,
          backgroundColor: Color.fromARGB(255, 0, 0, 0)),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: tokenExists! ? HomePage() : LoginPage(),
    );
  }
}
