


import 'package:flutter/material.dart';
class LineModel {
  var start;
  var end;
  LineModel( {this.start,this.end});

   setStart(double x,double y){
    start=   new Offset(x, y);
  }

}