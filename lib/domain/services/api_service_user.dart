import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

Future attemptLogin(String username, String password) async {
  try {
    if (username.isEmpty || password.isEmpty) {
      throw ("Username or Password is empty");
    }
    var res = await http.post(
      Uri.parse(ApiConstants.users.loginEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    Map<String, dynamic> map = jsonDecode(res.body);
    if (res.statusCode == 200) {
      // Login success
      dev.log("Writing token into storage...");
      storage.write(key: "username", value: username);
      storage.write(key: "token", value: map["token"]);
      storage.write(key: "uuid", value: map["uuid"]);
      dev.log("Wrote token into storage");
      return 0;
    } else {
      // Login fail
      // Todo: Visual error handling
      dev.log('${res.statusCode} // ${map["message"]}');
      return map["message"];
    }
  } catch (e) {
    return e.toString();
  }
}

Future createAccount(
    String username, String password, String secondPassword) async {
  try {
    if (username.isEmpty || password.isEmpty) {
      throw ("Username or Password is empty");
    } else if (password != secondPassword) {
      throw ("Password doesn't match!");
    }
    var res = await http.post(
      Uri.parse(ApiConstants.users.registerEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    Map<String, dynamic> map = jsonDecode(res.body);
    if (res.statusCode == 201) {
      // Register success
      return 0;
    } else {
      // Login fail
      dev.log('${res.statusCode} // ${map["message"]}');
      return map["message"];
    }
  } catch (e) {
    return e.toString();
  }
}

Future getUserByUsername(String username) async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    return -1;
  }

  var res = await http.get(
    Uri.parse(ApiConstants.users.getUserByUsernameEndpoint(username)),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return await jsonDecode(res.body)['user'];
}

Future getUserByUuid(String uuid) async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    return -1;
  }

  var res = await http.get(
    Uri.parse(ApiConstants.users.getUserByUuidEndpoint(uuid)),
    headers: <String, String>{
      'Authorization': token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return await jsonDecode(res.body)['user'];
}

Future addUserAsFriend(String username) async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    return -1;
  }
}

Future logout(BuildContext context) async {
  await storage.delete(key: "token");
  await storage.delete(key: "uuid");
  await storage.delete(key: "username");
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false,
  );
  return 0;
}
