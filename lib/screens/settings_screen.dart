import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get/get.dart';

import 'package:flutter_mindfuck_painter/domain/services/api_service_user.dart';
import 'package:flutter_mindfuck_painter/domain/services/error_popup_handler_service.dart';
import 'package:flutter_mindfuck_painter/domain/models/user_model.dart';

// ignore: prefer_const_constructors
final storage = FlutterSecureStorage();

bool developer = false;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  ThemeMode? newThemeMode;
  String? version;

  void initData() async {
    User.loadFromStorage()
        .then((value) => user = value)
        .whenComplete(() => setState(
              () {},
            ));
    PackageInfo.fromPlatform()
        .then((value) =>
            version = "${value.version} (build ${value.buildNumber})")
        .whenComplete(() => setState(
              () {},
            ));
    return;
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: SettingsList(
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
                  onPressed: (context) => showNoticeSnackbar(
                    context: context,
                    message:
                        "No other languages are supported at the moment - sorry!",
                  ),
                ),
                SettingsTile(
                    leading: const Icon(Icons.format_paint),
                    title: const Text("Select Theme"),
                    value: const Text(
                        "Choose between light and dark theme, or just let us handle it."),
                    onPressed: (context) => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Choose a theme"),
                            content: const Text(
                                "You're either on the light, or the dark side. You can't be on both."),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await storage.write(
                                        key: "theme", value: "light");
                                    Get.changeThemeMode(ThemeMode.light);
                                    setState(() {});
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
                                    Get.changeThemeMode(ThemeMode.dark);
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
                                    Get.changeThemeMode(ThemeMode.system);
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
                leading: Icon(
                    color: Theme.of(context).colorScheme.secondary,
                    Icons.logout),
                title: const Text("Log out"),
                description: Text(user != null
                    ? "Currently logged in as ${user!.username}."
                    : "Hang on..."),
                onPressed: (context) => logout(context),
              ),
              SettingsTile(
                  title: Text(
                      user == null && version == null
                          ? "Hang on..."
                          : "v${version != null ? version! : 'Unknown'} \nYour UUID: ${user != null ? user!.uuid : 'Still loading...'}",
                      style: Theme.of(context).textTheme.labelSmall))
            ]),
            if (developer)
              SettingsSection(
                  title: const Text("Developer Settings"),
                  tiles: <SettingsTile>[
                    SettingsTile(
                      leading: Icon(Icons.developer_mode),
                      title: const Text("Test get username api"),
                      onPressed: (context) async {
                        var a = await getUserByUsername("flutter");
                        log(a['uuid']);
                      },
                    )
                  ]),
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
