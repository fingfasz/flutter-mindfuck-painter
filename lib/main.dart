import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_heartbeat.dart';

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

bool? tokenExists;
ThemeMode? customThemeMode;
ConnectionManager connectionMan = ConnectionManager();
bool isConnected = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tokenExists = await storage.containsKey(key: "token");
  String? readTheme = await storage.read(key: "theme");
  customThemeMode = readTheme == "dark"
      ? ThemeMode.dark
      : readTheme == "light"
          ? ThemeMode.light
          : null;
  connectionMan
      .checkConnection(const Duration(seconds: 10), isConnected)
      .listen((connectionStatus) {
    isConnected = connectionStatus;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.purple, brightness: Brightness.light);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.purple, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((lightDynamic, darkDynamic) => GetMaterialApp(
              title: 'Mindfuck',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightDynamic ?? _defaultLightColorScheme,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                colorScheme: darkDynamic ?? _defaultDarkColorScheme,
                useMaterial3: true,
                brightness: Brightness.dark,
              ),
              themeMode: customThemeMode ?? ThemeMode.system,
              debugShowCheckedModeBanner: false,
              home: tokenExists! ? const HomePage() : const LoginPage(),
            )));
  }
}
