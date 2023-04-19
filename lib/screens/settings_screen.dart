import 'package:flutter/material.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:settings_ui/settings_ui.dart';

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();
ThemeMode? newThemeMode;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? username;

  Future<void> getUsername() async {
    await storage
        .read(key: "username")
        .then((value) => username = value ?? "nobody");
    setState(() {});
    return;
  }

  void initData() {
    getUsername();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: SettingsList(
          platform: DevicePlatform.android,
          physics: const AlwaysScrollableScrollPhysics(),
          sections: [
            SettingsSection(
              title: const Text("Application"),
              tiles: <SettingsTile>[
                SettingsTile(
                  leading: const Icon(Icons.language),
                  enabled: true,
                  title: const Text('Language'),
                  value: const Text('English - only language supported'),
                  onPressed: (context) => showNoticeSnackbar(context,
                      "No other language are supported at the moment - sorry!"),
                ),
                SettingsTile(
                    leading: Icon(Icons.format_paint),
                    title: Text("Select Theme"),
                    value: Text(
                        "Choose between light and dark theme, or just let us handle it."),
                    onPressed: (context) => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Choose a theme"),
                            content: Text(
                                "Choose between light, dark and system theme."),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await storage.write(
                                        key: "theme", value: "light");
                                    // Change the active theme
                                    Navigator.pop(context);
                                  },
                                  child: Row(children: const [
                                    Icon(Icons.light_mode),
                                    SizedBox(width: 10),
                                    Text("Light")
                                  ])),
                              TextButton(
                                  onPressed: () async {
                                    await storage.write(
                                        key: "theme", value: "dark");
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Row(children: const [
                                    Icon(Icons.dark_mode),
                                    SizedBox(width: 10),
                                    Text("Dark")
                                  ])),
                              TextButton(
                                  onPressed: () async {
                                    await storage.write(
                                        key: "theme", value: "system");
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Row(children: const [
                                    Icon(Icons.android),
                                    SizedBox(width: 10),
                                    Text("System")
                                  ])),
                            ],
                          );
                        })),
              ],
            ),
            SettingsSection(title: const Text("Account"), tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log out"),
                description: Text(username != null
                    ? "Currently logged in as $username."
                    : "Hang on..."),
                onPressed: (context) => logout(context),
              ),
            ])
          ],
        ));
  }
}

// // TODO: Very temporary settings page; no actual settings yet
// class _SettingsPageState extends State<SettingsPage> {
//   String? owo = storage.read(key: "token").toString();
//   String? uwu = storage.read(key: "uuid").toString();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text("Settings"),
//         ),
//         body: Center(
//             child: Column(
//           children: [
//             Container(
//               child: Text(
//                   owo == "Instance of 'Future<String?>'" ? "Token here" : owo!),
//             ),
//             Container(
//               child: Text(
//                   owo == "Instance of 'Future<String?>'" ? "UUID here" : uwu!),
//             ),
//             ElevatedButton(
//               onPressed: () async => await storage.deleteAll(),
//               child: Text("Reset storage (and then restart)"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 owo = await storage.read(key: "token");
//                 uwu = await storage.read(key: "uuid");

//                 setState(() {});
//               },
//               child: Text("Get token"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 var a = await getUserByUsername('test1');
//                 log(a.toString());

//                 setState(() {});
//               },
//               child: Text("Test Get User"),
//             ),
//           ],
//         )));
//   }
// }
