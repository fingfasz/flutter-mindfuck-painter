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

// TODO: Very temporary settings page; no actual settings yet
class _SettingsPageState extends State<SettingsPage> {
  String? owo = storage.read(key: "token").toString();
  String? uwu = storage.read(key: "uuid").toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              child: Text(
                  owo == "Instance of 'Future<String?>'" ? "Token here" : owo!),
            ),
            Container(
              child: Text(
                  owo == "Instance of 'Future<String?>'" ? "UUID here" : uwu!),
            ),
            ElevatedButton(
              onPressed: () async => await storage.deleteAll(),
              child: Text("Reset storage (and then restart)"),
            ),
            ElevatedButton(
              onPressed: () async {
                owo = await storage.read(key: "token");
                uwu = await storage.read(key: "uuid");

                setState(() {});
              },
              child: Text("Get token"),
            ),
            ElevatedButton(
              onPressed: () async {
                var a = await getUserByUsername('test1');
                log(a.toString());

                setState(() {});
              },
              child: Text("Test Get User"),
            ),
          ],
        )));
  }
}
