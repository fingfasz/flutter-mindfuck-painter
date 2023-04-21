import 'package:flutter/material.dart';

Future<void> showErrorSnackbar(
        {required BuildContext context, required String message}) async =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
          message),
    ));

Future<void> showNoticeSnackbar(
        {required BuildContext context, required String message}) async =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            message)));
