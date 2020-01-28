import 'dart:async';

import 'package:example/model/topic_model.dart';

String latestVersion;

List<TopicModel> topicList=[];
List<TopicModel> sentenceList=[];
List<TopicModel> multiList=[];

class Msg {
  static final SUCCESS = "0";
  String code;
  String desc;
  Object object;
}

