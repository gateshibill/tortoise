import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/model/line_model.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

  int result = 0;
  if (!isPlay) {
    isPlay = false;
    command = "暂停";
    await mediaController.setAssetDataSource("assets/music/naturespath.mp3", autoPlay: true);
    await mediaController.play();
  } else {
    isPlay = true;
    command = "播放";
    mediaController.pause();
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;    // X方向的偏移量
  double offsetY;    // Y方向的偏移量
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
            width:30,
            height: 20,
            child:Text("滑动"),
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
