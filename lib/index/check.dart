import 'dart:math';

import 'package:example/common/data.dart';
import 'package:flutter/material.dart';

double PI = 3.14159265;

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> with TickerProviderStateMixin {
  AnimationController animationController;
  double average;
  List<int> records = [];
  double rate;
  String resultTip;
  double lastTime = 0;
  double time = 0;
  String text="开始";

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
                              painter: TimerPainter(
                                  animation: animationController,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            AnimatedBuilder(
                                animation: animationController,
                                builder: (_, Widget child) {
                                  return Text(
                                    timerString,
                                    style: Theme.of(context).textTheme.display3,
                                  );
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
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
                        time == 0 ? "　　　　　　　　开始　　　　　　　　" :"　　　　　　　　结束　　　　　　　　" ,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        "　　　　　　　　　　　　　　　　　　　",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      controlButtons(),

                      Text(
                        "　　　　　　　　　　　　　　　　　　　",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        "　　　　　　　　　　　　　　　　　　　",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      result()
                    ],
                  ),
            )))
          ],
        ),
      ),
    );
  }

  Widget controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      //  FloatingActionButton(
          //child:
          AnimatedBuilder(
              animation: animationController,
              builder: (_, Widget child) {
                return Icon(animationController.isAnimating
                    ? Icons.pause
                    : Icons.play_arrow);
              }),
      ],
    );
  }

  void swithButton() {
    setState(() {
      print("animationController:${animationController.isAnimating}");
      double now = animationController.duration.inSeconds *
          animationController.value;
      if (animationController.isAnimating) {
        animationController.stop();
        time = lastTime - now;
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
        time = 0;
      }
      print(
          "current:$lastTime|$now|$time|${animationController.value}");
      lastTime = animationController.duration.inSeconds *
          animationController.value;
    });
  }

  Widget result() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          time == 0 ? "　　　　　　　　　　　　　" : getTime(time),
          style: Theme.of(context).textTheme.headline,
        ),
        Text(
          time == 0 ? "　　　　　　　　　　　　　" : getRate(time),
          style: Theme.of(context).textTheme.headline,
        ),
//        Text(
//          time == 0 ? "风又飘飘，雨又萧萧" : "",
//          style: Theme.of(context).textTheme.subhead,
//        ),
//        Text(
//    time == 0 ? "红了樱桃，绿了芭蕉" : "",
//          style: Theme.of(context).textTheme.subhead,
//        ),
        Text(
          topicList[Random().nextInt(topicList.length)].content,
          style: Theme.of(context).textTheme.subhead,
        ),
        Text(
          "",
          style: Theme.of(context).textTheme.subhead,
        ),
      ],
    );
  }
}

String getTime(double timeCount) {
  double rate = 0;
  String tip = "";
  if (timeCount < 10) {
    tip = "BOLT成绩:${formatNum(timeCount, 2)}秒";
  } else if (timeCount > 9 && timeCount < 51) {
    rate = (timeCount - 20) / 20 * 30 + 60;
    tip = "BOLT成绩:${formatNum(timeCount, 2)}秒";
  } else {
    tip = "BOLT成绩:${formatNum(timeCount, 2)}秒 ";
  }
// String resutl="BOLT成绩:$timeCount,超过百分之$rate";
  return tip;
}

String getRate(double timeCount) {
  double rate = 0;
  String tip = "";
  if (timeCount < 10) {
    tip = "偏低，需要改善!";
  } else if (timeCount > 9 && timeCount < 51) {
    rate = (timeCount - 20) / 20 * 30 + 60;
    tip = "超过${formatNum(rate, 2)}%";
  } else {
    tip = "非常好，请继续保持!";
  }
// String resutl="BOLT成绩:$timeCount,超过百分之$rate";
  return tip;
}

double getAverage(List<int> records) {
  double average = 0;
  if (records.length == 0) {
    return average;
  }
  double total = 0;
  records.forEach((f) {
    total += f;
  });
  average = total / records.length;
}

String formatNum(double num, int postion) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < postion) {
    //小数点后有几位小数
    return (num.toStringAsFixed(postion)
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString());
  } else {
    return (num.toString()
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString());
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()
//      ..color = backgroundColor
//      ..strokeWidth = 5.0
//      ..strokeCap = StrokeCap.round
//      ..style = PaintingStyle.stroke;
//
//    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//    paint.color = color;
//    double progress = (1.0 - animation.value) * 2 * PI;
//    canvas.drawArc(Offset.zero & size, PI * 1.2, -progress, false, paint);
//    // TODO: implement paint
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
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
