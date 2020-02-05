


import 'package:flutter/material.dart';
class LineModel {
  Offset start;
  Offset end;

  LineModel( {this.start,this.end});

   setStart(double x,double y){
    start=   new Offset(x, y);
  }

  LineModel copy(){
    return new LineModel(start:Offset(this.start.dx,this.start.dy),end:Offset(this.end.dx,this.end.dy));
  }
}