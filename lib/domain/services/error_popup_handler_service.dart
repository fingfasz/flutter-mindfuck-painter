import 'package:flutter/material.dart';

Future showErrorSnackbar(BuildContext context, String message) async =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(message)));

Future showNoticeSnackbar(BuildContext context, String message) async =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(message)));
