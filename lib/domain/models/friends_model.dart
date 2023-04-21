// import 'package:flutter/material.dart';
// import 'package:flutter_mindfuck_painter/domain/models/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FriendList {
//   List<User> friends = [];
//   bool showList = false;

//   // This will add a friend to the list.
//   void addFriend(String username, String uuid) {
//     friends.add(User(username: username, uuid: uuid));
//   }

//   // This will save the list to the phone.
//   void saveList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setStringList(
//         'friend_list', friends.map((friend) => friend.username).toList());
//   }

//   // This will load the list from the phone.
//   void loadList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> friendList = prefs.getStringList('friend_list');
//     if (friendList != null) {
//       for (int i = 0; i < friendList.length; i++) {
//         friends.add(User(friendList[i], friendList[i]));
//       }
//     }
//   }
// }
