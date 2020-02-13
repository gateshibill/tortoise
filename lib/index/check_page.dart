import 'dart:math';

import 'package:example/common/data.dart';
import 'package:example/common/widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/config.dart';

class CheckPage extends StatefulWidget {
  bool isback=false;
  CheckPage([isback=false]){
    this.isback=isback;
  }
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> with TickerProviderStateMixin {
  AnimationController animationController;
  double average;
  List<int> records = [];
  double rate;
  String resultTip;
  double lastTime = 0;
  double spentTime = 0;
  String commandText = "开始";
  int state = 0;
  static bool isShowTip = false;

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${((60-duration.inSeconds) % 60)
        .toString()
        .padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    setState(() {});
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
    spentTime = 0;
    state = 0;
    commandText = "开始";
    animationController.dispose();
    //mediaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        title: Text('BOLT测试'),
//      ),
      body: GestureDetector(
          onTap: () {
            setState(() {
              isShowTip = true;
            });
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg12.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
              Text(
              " BOLT测试",
            ),
            Container(
              //1.空站位
                width: 500,
                height: 50,
                // color: Colors.black12,
                child: Row(children: <Widget>[
                  Container(
                    width: 10,
                    height: 50,
                  ),
                  Text("晚上好 12:12",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  Container(
                    width: 200,
                    height: 50,
                  ),
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage("assets/images/bg12.jpg"),
                  )
                ])
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: 0 == state
                    ? indicator()
                    : AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder:
                              (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainter(
                                  animation: animationController,
                                  backgroundColor: Colors.white,
                                  color:
                                  Theme
                                      .of(context)
                                      .accentColor),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                                animation: animationController,
                                builder: (_, Widget child) {
                                  return Text(
                                    timerString,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .display3,
                                  );
                                }),
//                            Text(
//                              " BOLT测试",
//                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton(
                child: Text(commandText),
                color: Colors.brown,
                textColor: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  checkButton();
                }),
            Container(
                margin: EdgeInsets.all(8.0),
                child: new Container(
                    child: new GestureDetector(
                      onTap: () {
                        checkButton();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                          ),
                          result(),
                          Container(
                            height: 50,
                          ),
                          Container(
                              height: 50,
                              child: Text(
                                sentenceList[
                                Random().nextInt(sentenceList.length)]
                                    .content,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subhead,
                              )),
                        ],
                      ),
                    ))),
            !widget.isback?              Container(
              height: 50,
            ):Container(
              child: RaisedButton( //按钮
                child: Text('返回首页'),
                color: Colors.brown,
                textColor: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () { //相应按钮点击事件
                  // 通过MaterialPageRoute跳转逻辑 的具体执行
                  Navigator.pop(context);
                },
              )),
              ],
            ),
          )),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 300, -450),
      floatingActionButton: guide(isShowTip),
    );
  }

  Widget indicator() {
    return new Text(boltTip, //
      maxLines: 6, //最大行数
      overflow: TextOverflow.ellipsis, //超出显示省略号
      style: new TextStyle(
        color: Colors.deepPurple,
        fontSize: 22.0,
        //  background: Paint()..color = Colors.white,
      ),
    );
  }

  void checkButton() {
    setState(() {
      print("animationController:${animationController.isAnimating}");
      double now =
          animationController.duration.inSeconds * animationController.value;
      if (animationController.isAnimating) {
        animationController.stop();
        spentTime = lastTime - now;
        commandText = "开始";
        state = 0;
        animationController.reset();
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
        spentTime = 0;
        commandText = "结束";
        state = 1;
      }
      print("current:$lastTime|$now|$spentTime|${animationController.value}");
      lastTime =
          animationController.duration.inSeconds * animationController.value;
    });
  }

  Widget result() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          spentTime == 0 ? "" : getScoreTips(spentTime),
          style: new TextStyle(
            color: Colors.redAccent,
            fontSize: 22.0,
            background: Paint()
              ..color = Colors.white,
          ),
        ),
        Text(
          spentTime == 0 ? "" : getRateTips(spentTime),
          style: new TextStyle(
            color: Colors.redAccent,
            fontSize: 22.0,
            background: Paint()
              ..color = Colors.white,
          ),
        ),
//        Text(
//          sentenceList[Random().nextInt(sentenceList.length)].content,
//          style: Theme.of(context).textTheme.subhead,
//        ),
        Text(
          "",
          style: Theme
              .of(context)
              .textTheme
              .subhead,
        ),
      ],
    );
  }
}

String getScoreTips(double timeCount) {
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

String getRateTips(double timeCount) {
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
  if ((num
      .toString()
      .length - num.toString().lastIndexOf(".") - 1) < postion) {
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
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * PI;
    canvas.drawArc(
        new Offset(33, 33) & size * 0.8, PI * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
