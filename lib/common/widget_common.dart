import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/model/line_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'config.dart';
import 'data.dart';

Widget myAnimation(AnimationController animationController) {
  return AnimatedBuilder(
    animation: animationController,
    builder: (BuildContext context, Widget child) {
      return CustomPaint(
        painter: TimerPainter(
            animation: animationController,
            backgroundColor: Colors.white,
            color: Theme.of(context).accentColor),
      );
    },
  );
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * PI;
    canvas.drawArc(
        new Offset(36, 36) & size * 0.8, PI * 1.5, progress, false, paint);
    canvas.drawLine(new Offset(0, 0), new Offset(progress * 50, 0), paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class TimerPainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  int breath = -1;
  List<LineModel> lines = [];
  Offset lastOffset = new Offset(0, 0);

  TimerPainterLiner({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * PI;
    canvas.drawArc(
        new Offset(36, 36) & size * 0.8, PI * 1.5, progress, false, paint);

    if (1 == breath) {
      Offset current = Offset(progress * 50, 10);
      LineModel model = new LineModel(start: lastOffset, end: current);
      lines.add(model);
      lastOffset = new Offset(progress * 50, 10);
    } else if (0 == breath) {
      Offset current = Offset(progress * 50, 0);
      LineModel model = new LineModel(start: lastOffset, end: current);
      lines.add(model);
      lastOffset = new Offset(progress * 50, 0);
    }
    for (LineModel model in lines) {
      canvas.drawLine(model.start, model.end, paint);
    }
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

void play() async {
  print("play()|$isPlay");
  isPlay = true;
  command = "暂停";
  //mediaController = new IjkMediaController();
  currentMusicIndex=Random().nextInt(musicList.length);
  print("play()|$isPlay|$currentMusicIndex");
  await mediaController.setAssetDataSource(musicList[currentMusicIndex],
      autoPlay: true);
}
void playNext() async {
  print("play()|$isPlay");
  isPlay = true;
  command = "暂停";
//  mediaController = new IjkMediaController();
  currentMusicIndex=((musicList.length-1)==currentMusicIndex)?0: currentMusicIndex+1;
  await mediaController.setAssetDataSource(musicList[currentMusicIndex],
      autoPlay: true);
}

void stop() {
  print("stop()|$isPlay");
  isPlay = false;
  command = "播放";
  mediaController.reset();
}

void playAudio(String url) async {
  audioController.setAssetDataSource(url, autoPlay: true);
  await audioController.play();
  audioController.reset();
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

Widget guide(bool isShowTip) {
  return new Offstage(
      offstage: isShowTip,
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 20,
            child: Text("滑动"),
          ),
          Container(
            width: 10,
            height: 20,
            // child:Text("滑动"),
          ),
          Container(
            width: 20,
            height: 20,
            child: Icon(FontAwesome.hand_o_right),
          ),
//          Container(
//            //1.空站位
//              width: 20,
//              height: 10,
//              // color: Colors.black12,
//              child: Icon(FontAwesome.hand_o_left)),
        ],
      ));
}

TravelModel getOptimalTravelModel(List<Offset> points) {
  TravelModel travelModel = new TravelModel();
  Offset lastPoint = null;
  Offset startPont = new Offset(0, 0);
  double sum = 0;
  points.forEach((f) {
    sum += f.dy;
  });
  double average = sum / points.length;
  points.forEach((f) {
    sum += f.dy;
  });

  //去噪点，小于平均值一半的为噪点
  List<Offset> newPoints = [];
  points.forEach((f) {
    if (f.dy > average*0.5) {
      newPoints.add(f);
    }
  });
  print("getOptimalTravelModel() points=${points.length}|${newPoints.length}");
  newPoints.forEach((f) {
    if (null != lastPoint) {
      if ((f.dx - lastPoint.dx) > 6 * 6) {
        Offset afterPoint = new Offset(lastPoint.dx + 3 * 6, 0);
        Offset beforePoint = new Offset(f.dx - 3 * 6, 0);

        LineModel prevoiusLineModel =
            new LineModel(start: lastPoint, end: afterPoint);
        travelModel.addLineModel(prevoiusLineModel);

        LineModel supplieLineModel =
            new LineModel(start: afterPoint, end: beforePoint);
        travelModel.addLineModel(supplieLineModel);

        Offset currentPoint = new Offset(f.dx, -16);
        LineModel currentLineModel =
            new LineModel(start: beforePoint, end: currentPoint);
        travelModel.addLineModel(currentLineModel);

        lastPoint = new Offset(f.dx, -16);
      } else {
        double x = lastPoint.dx + (f.dx - lastPoint.dx) / 2;
        Offset afterPoint = new Offset(x, 0);
        Offset beforePoint = new Offset(x, 0);

        LineModel prevoiusLineModel =
            new LineModel(start: lastPoint, end: afterPoint);
        travelModel.addLineModel(prevoiusLineModel);

        Offset currentPoint = new Offset(f.dx, -16);
        LineModel currentLineModel =
            new LineModel(start: beforePoint, end: currentPoint);
        travelModel.addLineModel(currentLineModel);

        lastPoint = new Offset(f.dx, -16);
      }
    } else {
      //第一个点
      lastPoint = new Offset(f.dx, -16);
    }

//    LineModel lineModel =
//    new LineModel(start: lastPoint, end: new Offset(f.d)f);
//    travelModel.addLineModel(lineModel);
  });

  return travelModel;
}
