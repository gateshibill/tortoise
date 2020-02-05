
import 'package:flutter/material.dart';


class BreathModel {

  DateTime dateTime;
  int type;//0为屛吸，1为吸，2为呼

  BreathModel( {this.dateTime,this.type});


  BreathModel copy(){
    return new BreathModel(dateTime:dateTime,type:type);
  }
}