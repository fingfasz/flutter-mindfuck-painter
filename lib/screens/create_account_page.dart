import 'package:flutter/material.dart';

import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _secondPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm password',
                ),
              ),
            ),
            ButtonBar(alignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  var a = await createAccount(_usernameController.text,
                      _passwordController.text, _secondPasswordController.text);
                  if (a == 0) {
                    Navigator.pop(context);
                  } else {
                    showErrorSnackbar(
                        context: context, message: "Error: ${a.toString()}");
                  }
                },
                child: const Text("Register"),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
