// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) {
  return ExamModel()
    ..average = (json['average'] as num)?.toDouble()
    ..records = json['records'] as List
    ..rate = (json['rate'] as num)?.toDouble()
    ..resultTip = json['resultTip'] as String
    ..dateTime = json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String);
}

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
      'average': instance.average,
      'records': instance.records,
      'rate': instance.rate,
      'resultTip': instance.resultTip,
      'dateTime': instance.dateTime?.toIso8601String()
    };
