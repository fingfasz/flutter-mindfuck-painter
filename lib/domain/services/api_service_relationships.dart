import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_mindfuck_painter/screens/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();
