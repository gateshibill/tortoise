


import 'package:example/model/line_model.dart';

class TravelModel {
  DateTime  dateTime=new DateTime.now();
  List<LineModel> list=[];
  TravelModel();

 addLineModel(LineModel model){
   list.add(model);
  }

  TravelModel copy(){
    TravelModel model=new TravelModel();
    //model.list.addAll(this.list);
    list.forEach((f){
      model.list.add(f.copy());
    });
    model.dateTime=this.dateTime;
    return model;
  }
}