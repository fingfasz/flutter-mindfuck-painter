import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? owo = storage.read(key: "token").toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              child: Text(owo == null ? "Waiting..." : owo!),
            ),
            ElevatedButton(
              onPressed: () async => await storage.deleteAll(),
              child: Text("Delete token (and then restart)"),
            ),
            ElevatedButton(
              onPressed: () async {
                owo = await storage.read(key: "token");
                setState(() {});
              },
              child: Text("Get token"),
            ),
          ],
        )));
  }
}
