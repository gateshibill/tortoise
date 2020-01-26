// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) {
  return TopicModel()
    ..id = json['id'] as int
    ..officialAccountId = json['officialAccountId'] as int
    ..header = json['header'] as String
    ..name = json['name'] as String
    ..title = json['title'] as String
    ..summary = json['summary'] as String
    ..content = json['content'] as String
    ..poster = json['poster'] as String
    ..url = json['url'] as String
    ..type = json['type'] as int
    ..audience = json['audience'] as String
    ..hits = json['hits'] as int
    ..applauds = json['applauds'] as int
    ..status = json['status'] as int
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String);
}

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'officialAccountId': instance.officialAccountId,
      'header': instance.header,
      'name': instance.name,
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'poster': instance.poster,
      'url': instance.url,
      'type': instance.type,
      'audience': instance.audience,
      'hits': instance.hits,
      'applauds': instance.applauds,
      'status': instance.status,
      'createTime': instance.createTime?.toIso8601String()
    };
