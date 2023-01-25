import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

Future attemptLogin(String username, String password) async {
  try {
    if (username.isEmpty || password.isEmpty) {
      throw ("Username or Password is empty");
    }
    var res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/login'),
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
      dev.log("Wrote token into storage");
      storage.write(key: "token", value: map["token"]);
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
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/register'),
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

Future getUser(String uuid) async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    return 1;
  }

  final queryParameters = jsonEncode(<String, String>{
    "token": token,
  });

  var res = await http.get(
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${uuid}'),
    headers: <String, String>{
      'Authorization': token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}
