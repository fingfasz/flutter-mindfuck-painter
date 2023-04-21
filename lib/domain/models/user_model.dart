import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class User {
  String? username;
  String? uuid;

  User({required this.username, required this.uuid});

  static Future<User> loadFromStorage() async {
    User user = User(username: null, uuid: null);

    await storage
        .read(key: "username")
        .then((value) => user.username = value ?? "nobody");
    await storage
        .read(key: "uuid")
        .then((value) => user.uuid = value ?? "Unknown");
    return user;
  }
}
