


import 'package:example/model/line_model.dart';

class TravelModel {
  DateTime  dateTime=new DateTime.now();
  List<LineModel> list=[];
  TravelModel();
  int state;

 addLineModel(LineModel model){
   list.add(model);
  }

}