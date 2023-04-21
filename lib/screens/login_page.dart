import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:flutter_mindfuck_painter/screens/create_account_page.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome!"),
        centerTitle: true,
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
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 36)),
                  onPressed: _isButtonDisabled
                      ? null
                      : () async {
                          setState(() => _isButtonDisabled = true);
                          var a = await attemptLogin(_usernameController.text,
                              _passwordController.text);
                          if (a == 0) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false);
                          } else {
                            showErrorSnackbar(
                                context: context,
                                message: "Error: ${a.toString()}");
                          }
                          setState(() => _isButtonDisabled = false);
                        },
                  child: _isButtonDisabled
                      ? const CircularProgressIndicator()
                      : const Text("Log in"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAccountPage())),
                  child: const Text("Create Account"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
