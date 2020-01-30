import 'dart:math';

import 'package:example/common/data.dart';
import 'package:example/common/widget_common.dart';
import 'package:example/model/line_model.dart';
import 'package:flutter/material.dart';

double PI = 3.14159265;
int breath=-1;
List<LineModel> lines=[];
Offset lastOffset =new Offset(0, 0);

class DrawLinePage extends StatefulWidget {
  @override
  _DrawLinePageState createState() => _DrawLinePageState();
}

class _DrawLinePageState extends State<DrawLinePage> with TickerProviderStateMixin {
  AnimationController animationController;
  double average;
  List<int> records = [];
  double rate;
  String resultTip;
  double lastTime = 0;
  double spentTime = 0;
  String commandText="开始";
  int state=0;


  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('BOLT测试'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainterLiner(
                                  animation: animationController,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(4.0),
                child:
                new Container(
                    child: new GestureDetector(
                      onTap: () {
                        swithButton();
                      },
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "　　　　　　　　　　　　　　　　　　　",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Text(
                            "　　　　　　　　　　　　　　　　",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Text(
                            state == 0 ? "　　　　　　　　开始　　　　　　　　" :"　　　　　　　　结束　　　　　　　　" ,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Text(
                            "　　　　　　　　　　　　　　　　　　　",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ],
                      ),
                    ))),
        new Container(
            child:  GestureDetector(
              onTap: () {
                breathButton();
              },
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    "　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    state == 0 ? "　　　　　　　　吸气　　　　　　　　" :"　　　　　　　　呼气　　　　　　　　" ,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  //   controlButtons(),

                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    "　　　　　　　　　　　　　　　　　　　",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  //result()
                ],
              ),
            )),
            new Container(
                child: new GestureDetector(
                  onTap: () {
                    clearButton();
                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "　　　　　　　　　　　　　　　　",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        state == 0 ? "　　　　　　　　結束　　　　　　　　" :"　　　　　　　　結束　　　　　　　　" ,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        "　　　　　　　　　　　　　　　　　　　",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                         ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void swithButton() {
    setState(() {
      print("animationController:${animationController.isAnimating}");
      double now = animationController.duration.inSeconds *
          animationController.value;
      if (animationController.isAnimating) {
        animationController.stop();
        spentTime = lastTime - now;
        state=0;
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
        spentTime = 0;
        state=1;
      }
      print(
          "current:$lastTime|$now|$spentTime|${animationController.value}");
      lastTime = animationController.duration.inSeconds *
          animationController.value;
    });
  }
  void breathButton() {
    setState(() {
      breath=1==breath?0:1;
    });
  }
  void clearButton() {
    setState(() {
      animationController.dispose();
    });
  }
  @override
  void dispose() {
    // 释放资源
    animationController.dispose();
    super.dispose();
  }
}

//class TimerPainter extends CustomPainter {
//  final Animation<double> animation;
//  final Color backgroundColor;
//  final Color color;
//
//  TimerPainter({this.animation, this.backgroundColor, this.color})
//      : super(repaint: animation);
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    Paint paint = Paint()
//      ..color = backgroundColor
//      ..strokeWidth = 5.0
//      ..strokeCap = StrokeCap.round
//      ..style = PaintingStyle.stroke;
//
//    canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);
//    paint.color = color;
//    double progress = (1.0 - animation.value) * 2 * PI;
//    canvas.drawArc(
//        new Offset(36, 36) & size * 0.8, PI * 1.5, progress, false, paint);
//
//    if(1==breath){
//      Offset current= Offset(progress*50,10);
//      LineModel model = new LineModel(start: lastOffset,end: current);
//      lines.add(model);
//      lastOffset = new Offset(progress*50,10);
//    }else if(0==breath){
//      Offset current= Offset(progress*50,0);
//      LineModel model = new LineModel(start: lastOffset,end: current);
//      lines.add(model);
//      lastOffset = new Offset(progress*50,0);
//    }
//    for(LineModel model in lines){
//      canvas.drawLine(model.start, model.end, paint);
//    }
//
//  }
//
//  @override
//  bool shouldRepaint(TimerPainter old) {
//    return animation.value != old.animation.value ||
//        color != old.color ||
//        backgroundColor != old.backgroundColor;
//  }
//}
