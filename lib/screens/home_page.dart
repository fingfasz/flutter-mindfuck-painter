import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_mindfuck_painter/screens/settings_screen.dart';
import 'package:flutter_mindfuck_painter/screens/sketching_screen.dart';
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
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Add Friend'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Settings'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                    ),
                    SizedBox(width: 8),
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
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SketchingPage())),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
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
