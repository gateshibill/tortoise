import 'dart:convert';
import 'dart:io';

import 'package:example/common/data.dart';
import 'package:example/model/topic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


/**
 *
 */
class LocalStorage {
  static SharedPreferences sharedPreferences = null;
  static final String TAG = "LocalStorage";
  static final String topic_ = "topic_";
  static final String group_ = "group_";
  static final String member_ = "member_";
  static final String login_ = "login_";
  static final String officialAccountTopic = "officialAccountTopic";

  static Future<bool> init() async {
    await SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
    });
    readAllModel();
    return true;
  }

  static SharedPreferences instance() {
    return sharedPreferences;
  }
  static void readAllModel() {
    Set<String> keys = sharedPreferences.getKeys();
    for (String key in keys) {
      if (key.startsWith(topic_)){
        String modelJson = sharedPreferences.getString(key);
        final Map parsed = json.decode(modelJson);
        TopicModel model = TopicModel.fromJson(parsed);
        topicList.add(model);
      }
    }
  }


  static void setTopicModel(TopicModel model) {
    sharedPreferences.setString("${topic_}${model.id}.", json.encode(model));
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
