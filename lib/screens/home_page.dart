import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:flutter_mindfuck_painter/screens/settings_screen.dart';
import 'package:flutter_mindfuck_painter/screens/sketching_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  Future<void> getUsername() async {
    await storage
        .read(key: "username")
        .then((value) => username = value ?? "nobody");
    setState(() {});
    return;
  }

  void initData() {
    getUsername();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text(username != null ? "Welcome, $username!" : "Welcome, user!"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(children: const [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('Add Friend'),
                  ])),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(children: const [
                    Icon(Icons.person_remove),
                    SizedBox(width: 8),
                    Text('Remove Friend'),
                  ])),
              PopupMenuItem<int>(
                  value: 2,
                  child: Row(children: const [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ])),
            ],
          ),
        ],
      ),
      body: Center(
          child: Column(
        // TODO: UI: Add sketches
        children: [],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SketchingPage())),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        showErrorSnackbar(context, "Not implemented yet!");
        break;
      case 1:
        showErrorSnackbar(context, "Not implemented yet!");
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }
}
