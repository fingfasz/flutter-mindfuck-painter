import 'package:dynamic_color/dynamic_color.dart';
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

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.purple);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.purple, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((lightDynamic, darkDynamic) => MaterialApp(
              title: 'Mindfuck',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightDynamic ?? _defaultLightColorScheme,
                brightness: Brightness.light,
                //  colorSchemeSeed: Colors.deepPurple,
              ),
              darkTheme: ThemeData(
                  colorScheme: darkDynamic ?? _defaultDarkColorScheme,
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  //colorSchemeSeed: Colors.purple,
                  backgroundColor: Color.fromARGB(255, 0, 0, 0)),
              themeMode: ThemeMode.dark,
              debugShowCheckedModeBanner: false,
              home: tokenExists! ? HomePage() : LoginPage(),
            )));
  }
}
