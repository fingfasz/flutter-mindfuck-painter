import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:ui';

import 'package:byte_util/byte_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_mindfuck_painter/domain/models/sketch_model.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

Future<Sketch> fetchSketch() async {
  String? token = await storage.read(key: "token");

  if (token == null) {
    // No token in storage
    throw 'No token';
  }

  final response = await http.get(
    Uri.parse(ApiConstants.sketches.getSketchEndpoint),
    headers: <String, String>{
      'Authorization': token,
      //'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    String? username;
    await getUserByUuid(jsonDecode(response.body)['uuid'])
        .then((value) => username = value['username']);

    return Sketch.fromJson(jsonDecode(response.body), username ?? "nobody");
  } else {
    throw Exception('Failed to load Sketch');
  }
}
