import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:ui';

import 'package:byte_util/byte_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:scribble/scribble.dart';

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

// TODO: UI: Figure out how to add background
// TODO: UI: Send sketch to server
Future<bool> renderImage(BuildContext context, ScribbleNotifier notifier,
    Color backgroundColor) async {
  final image = await notifier.renderImage(format: ImageByteFormat.png);

  var imageRaw = ByteUtil.toBase64(image.buffer.asUint8List());

  String bin = "$imageRaw;${backgroundColor.value}";

  dev.log(bin);

  // Show a dialog that asks the user for a username to send the sketch to.

  String targetUsername;

  final TextEditingController targetUsernameTextboxController =
      TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter target username'),
          content: TextField(
            controller: targetUsernameTextboxController,
            decoration: const InputDecoration(hintText: "limp_bizkit"),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z\-]")),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
                  iconColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.tertiary)),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
                  iconColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.tertiary)),
              child: const Text('Send'),
              onPressed: () async {
                targetUsername = targetUsernameTextboxController.text;
                if (targetUsername == null || targetUsername == "") {
                  return Future.value(false);
                }
                Navigator.of(context).pop();
                bool meow = await sendSketch(targetUsername, bin, context);
                return Future.value(meow);
              },
            ),
          ],
        );
      });
  return Future.value(false);
}

Future<bool> sendSketch(String target, String bin, BuildContext context) async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    return false;
  }

  var targetUser = await getUserByUsername("flutter");

  var res = await http.post(
      Uri.parse(ApiConstants.sketches.createSketchEndpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'receiverUUID': targetUser['uuid'], 'bin': bin}));

  if (res.statusCode == 201) {
    return true;
  } else {
    return false;
  }
  //return await jsonEncode(res.body)['user'];
}
