


import 'package:flutter/material.dart';
class LineModel {
  Offset start;
  Offset end;


  LineModel( {this.start,this.end});

   setStart(double x,double y){
    start=   new Offset(x, y);
  }

}