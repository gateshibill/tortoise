import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';


part 'topic_model.g.dart';

@JsonSerializable()
class TopicModel {
  int id;
  int officialAccountId;
  String header;// 公众号头像
  String name;// 公众号名称
  String title;
  String summary; //摘要
  String content;
  String poster; //海报
  String url;
  int type; //
  String audience;
  int hits;
  int applauds;
  int status;
  DateTime createTime;

  String get detail =>
      "id:$id|officialAccountId:$officialAccountId|header:$header|name:$name|title:$title|type:$type";



  TopicModel();

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}

class TopicModelList {
  List<TopicModel> topicModelList;

  TopicModelList({this.topicModelList});

  factory TopicModelList.fromJson(List<dynamic> listJson) {
    List<TopicModel> topicModelList =
        listJson.map((value) => TopicModel.fromJson(value)).toList();

    return TopicModelList(topicModelList: topicModelList);
  }
}
