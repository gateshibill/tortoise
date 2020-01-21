import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


/**
 *
 */
class LocalStorage {
  static SharedPreferences sharedPreferences = null;
  static final String TAG = "LocalStorage";
  static final String mm_ = "mm_";
  static final String group_ = "group_";
  static final String member_ = "member_";
  static final String login_ = "login_";
  static final String officialAccountTopic = "officialAccountTopic";

  static Future<bool> init() async {
    await SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
    });
    return true;
  }

  static SharedPreferences instance() {
    return sharedPreferences;
  }

  static void _eliminate() {
    Set<String> keys = sharedPreferences.getKeys();
    if (keys.length > 10000) {
      int count = 0;
      keys.forEach((key) {
        if (count < 1000) {
          sharedPreferences.remove(key);
        } else {
          return;
        }
      });
    }
  }

  static void getUserModel(String jid) {
    sharedPreferences.getString(jid);
  }

  static String getString(String key) {
    return sharedPreferences.get(key);
  }

  static void _saveString(String key, String value) async {
    sharedPreferences.setString(key, value);
  }

}
