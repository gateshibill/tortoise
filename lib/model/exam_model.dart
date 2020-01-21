import 'package:json_annotation/json_annotation.dart';

part 'exam_model.g.dart';

@JsonSerializable()
class ExamModel {
  double average;
  List<int> records = [];
  double rate;
  String resultTip;
  DateTime dateTime;

  ExamModel();



  factory ExamModel.fromJson(Map<String, dynamic> json) =>
      _$ExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamModelToJson(this);
}

class ExamModelList {
  List<ExamModel> examModelList;

  ExamModelList({this.examModelList});

  factory ExamModelList.fromJson(List<dynamic> listJson) {
    List<ExamModel> examModelList =
        listJson.map((dynamic value) => ExamModel.fromJson(value)).toList();

    return ExamModelList(examModelList: examModelList);
  }
}
