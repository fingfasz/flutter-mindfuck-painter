import 'dart:async';

import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:scribble/scribble.dart';

class Sketch {
  late String username;
  final String uuid;
  final String bin;

  Sketch({
    required this.uuid,
    required this.bin,
    required this.username,
  });

  factory Sketch.fromJson(Map<String, dynamic> json, String username) {
    return Sketch(
        uuid: json['receiverUUID'], bin: json['bin'], username: username);
  }
}
