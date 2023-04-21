import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/constants/api_constants.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

BuildContext? context = Get.context;

class ConnectionManager {
  Stream<bool> checkConnection(Duration timeToWait, bool status) async* {
    bool result = false;
    bool sentLostMessageAlready = false;

    while (true) {
      context = Get.context;
      try {
        await Future.delayed(const Duration(seconds: 1));
        result = await _sendHeartbeat();
      } catch (error) {
        result = false;
      } finally {
        if (status != result) {
          if (context != null && !result && !sentLostMessageAlready) {
            showErrorSnackbar(context:  context!,
                message: "Lost connection - but don't fret! We're working on it.");
            sentLostMessageAlready = true;
          } else if (context != null && result && sentLostMessageAlready) {
            showNoticeSnackbar(context: context!, message: "Connection re-established.");
            sentLostMessageAlready = false;
          }
          yield result;
        }
        await Future.delayed(timeToWait);
      }
    }
  }

  Future<bool> _sendHeartbeat() async {
    bool connection = false;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return connection;
    }

    for (var attempt = 0; attempt < 5; attempt++) {
      var res = await http.get(
        Uri.parse(ApiConstants.heartbeat),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      log("Heartbeat attempted. Got: ${res.statusCode}\nAttempt: $attempt");
      if (res.statusCode == 200) {
        connection = true;
        break;
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return connection;
  }
}
