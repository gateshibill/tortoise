


import 'package:example/model/line_model.dart';

class TravelModel {
  DateTime  dateTime=new DateTime.now();
  List<LineModel> list=[];
  int breathTime=0;//呼吸水平
  int level=0;//呼吸水平
  TravelModel();

 addLineModel(LineModel model){
   list.add(model);
  }

  TravelModel copy(){
    TravelModel model=new TravelModel();
    list.forEach((f){
      model.list.add(f.copy());
    });
    model.dateTime=this.dateTime;
    model.breathTime=this.breathTime;
    return model;
  }
}