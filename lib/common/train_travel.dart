import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/model/line_model.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config.dart';

 class TrainTravel {
 static Offset lastPoint;
 static  Offset currentPoint;
 static int startDateTime;
 //static int lastDatTime;
 static int currentTime;

 static LineModel  createLiner(int state) {
    LineModel model;
    switch (state) {
      case 0://停止
        break;
      case 1://屏息
       lastPoint=new Offset(0, 0) ;
       startDateTime= DateTime.now().second;
        break;
      case 2://吸气
        currentTime= DateTime.now().second;
        int distance=currentTime-startDateTime;
        int dy=0;
        currentPoint=new Offset(distance*1.0, dy*1.0);
        model=new LineModel(start:lastPoint,end:currentPoint);
        lastPoint= currentPoint;
        break;
      case 3://呼气
        currentTime= DateTime.now().second;
        int distance=currentTime-startDateTime;
        int dy=10;
        currentPoint=new Offset(distance*1.0, dy*1.0);
        model=new LineModel(start:lastPoint,end:currentPoint);
        lastPoint= currentPoint;
        break;
      default:
        break;
    }
    return model;
  }
}
