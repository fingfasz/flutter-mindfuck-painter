import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_mindfuck_painter/screens/settings_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Add Friend'),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Settings'),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Center(
            child: Column(
          children: [],
        )));
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        var snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Still under development"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 2:
        await storage.delete(key: "token");
        await storage.delete(key: "uuid");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
    }
  }
}
