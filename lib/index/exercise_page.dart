import 'dart:math';
import 'package:example/common/data.dart';
import 'package:example/model/line_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:flutter/material.dart';
import '../common/config.dart';
import 'check_page.dart';

int breath = -1;
TravelModel currentTravelModel = new TravelModel();
LineModel currentLineModel;
int state = 0;
int startDateTime;
int lastDateTime;
int currentTime;
double lastDy;
String command = '开始屏息';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with TickerProviderStateMixin {
  _ExercisePageState();

  AnimationController animationController;
  String bg = "assets/images/bg5.jpg";
  double width = 500;
  double height = 100;

  @override
  Widget build(BuildContext context) {
    print(bg);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              " 呼吸练习",
            ),
//            Container(
//              width: 200,
//              height: 20,
//            ),
            Container(
                //1.空站位
                width: width,
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
                    backgroundImage: AssetImage("assets/images/bg3.jpg"),
                  )
                ])),
            Container(
              //tips
              width: width,
              height: 100,
              // color: Colors.black12,
              child: Text(
                sentenceList[Random().nextInt(sentenceList.length)].content,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
//            Container(
//              width: 200,
//              height: 50,
//            ),
            Container(
              //1.训练1
              width: width,
              height: 70,
              alignment: Alignment.bottomLeft,
              child: Align(
                alignment: FractionalOffset.bottomLeft,
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
                                  color: Theme.of(context).accentColor,
                                  endCallback: endButton),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                                animation: animationController,
                                builder: (_, Widget child) {
                                  return Text(
                                    timerString,
                                    style: Theme.of(context).textTheme.display1,
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
            //屏息切换
            CircleAvatar(
              radius: 70.0,
              // backgroundImage: AssetImage("assets/images/bg3.jpg"),
              backgroundColor: Colors.blueGrey,
              child: RaisedButton(
                  child: Text(command,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  color: Colors.transparent,
                  textColor: Colors.white,
                  elevation: 100,
                  shape: CircleBorder(),
                  onPressed: () {
                    startButton();
                  }),
            ),

            //呼吸切换
            Container(
              //4.结束
              padding: const EdgeInsets.only(top: 30.0),
              width: 100,
              height: 70,
              // alignment: Alignment.bottomLeft,
              //color: Colors.black12,
              child: RaisedButton(
                  child: Text('结束'),
                  color: Colors.brown,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    endButton();
                  }),
            ),
//            Container(
//              //4.结束
//              width: 500,
//              height: 40,
//              alignment: Alignment.bottomLeft,
//              //color: Colors.black12,
//              child: RaisedButton(
//                  child: Text('清理'),
//                  color: Colors.blue,
//                  textColor: Colors.white,
//                  elevation: 20,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(15)),
//                  onPressed: () {
//                    clearButton();
//                  }),
//            ),
            Container(
              //4.中间站位
              width: width,
              height: 30,
              // color: Colors.black12,
            ),
            //分割线
            Container(
              //5.分割线
              width: width,
              height: 2,
              // color: Colors.grey[200],
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0)),
              ),
            ),
            Container(
              //4.中间站位
              width: width,
              height: 50,
              // color: Colors.black12,
            ),
            Container(
              //历史1
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, travelList.length - 1),
            ),
            Container(
              //历史2
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, travelList.length - 2),
            ),
            Container(
              //历史3
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, travelList.length - 3),
            ),
            Container(
              //历史4
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, travelList.length - 4),
            ),
            Container(
              //历史5
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, travelList.length - 5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
  }

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(60-(duration.inSeconds % 60)).toString().padLeft(2, '0')}';
  }

  Widget history() {
    print("history() travelList.length=${travelList.length}");
    int length = travelList.length;
    return ListView.builder(
      //  scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return getItem(context, length - index - 1);
      },
      itemCount: travelList.length,
    );
  }

  Widget getItem(BuildContext context, int index) {
    print("getItem() index=${index}");
    if (index < 0) {
      return new Text("");
    }
    TravelModel model = travelList[index];
    if (null == model) {
      return new Text("dd");
    }
    return getHistoryTravel(model);
  }

  Widget getHistoryTravel(TravelModel model) {
    if (null == model) {
      return new Text("dd");
    }
    return new Container(
      alignment: FractionalOffset.bottomLeft,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return CustomPaint(
                      painter: PainterLiner(
                          animation: null,
                          backgroundColor: Colors.white,
                          color: Theme.of(context).accentColor,
                          travelModel: model));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startButton() {
    print("startButton()");
    //state=1;
    setState(() {
      print("animationController:${animationController.isAnimating}");
      double now =
          animationController.duration.inSeconds * animationController.value;
      if (animationController.isAnimating) {
        // animationController.stop();
        //   spentTime = lastTime - now;
        //state=0;
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
      }

      switch (state) {
        case 0:
          state = 1;
          command = '吸气';
          Offset lastPoint = new Offset(0.0, 0.0);
          Offset currentPoint = new Offset(0.0, 0.0);
          currentLineModel = new LineModel(start: lastPoint, end: currentPoint);
          currentTravelModel.list.clear();
          currentTravelModel.addLineModel(currentLineModel);
          startDateTime = new DateTime.now().millisecondsSinceEpoch;
          lastDateTime = new DateTime.now().millisecondsSinceEpoch;
          break;
        case 1:
          state = 2;
          command = '呼气';
          breathButton();
          break;
        case 2:
          state = 3;
          command = '吸气';
          breathButton();
          break;
        case 3:
          state = 2;
          command = '呼气';
          breathButton();
          break;
        case 4:
          break;
      }
    });
  }

  void breathButton() {
    setState(() {
      breath = 1 == breath ? 0 : 1;
      if (1 == breath) {
        // state = 2;
        LineModel model = currentLineModel.copy();
        currentTravelModel.addLineModel(model);
        currentLineModel.start = currentLineModel.end;
      } else {
        // state = 3;
        LineModel model = currentLineModel.copy();
        currentTravelModel.addLineModel(model);
        currentLineModel.start = currentLineModel.end;
      }
      lastDateTime = new DateTime.now().millisecondsSinceEpoch;
      // travelList.add(currentTravelModel.copy());
    });
  }

  void endButton() {
    print("endButton()");
    setState(() {
      state = 0;
      command = '屏息';
      animationController.reset();
      //LineModel model = TrainTravel.createLiner(state);
      currentTravelModel.addLineModel(currentLineModel.copy());
      travelList.add(currentTravelModel.copy());
      //lastDateTime = new DateTime.now().millisecondsSinceEpoch;
    });
  }

  void clearButton() {
    setState(() {
      animationController.reset();
      travelList.clear();
    });
  }

  @override
  void dispose() {
    // 释放资源
    animationController.dispose();
    super.dispose();
  }
}

class TimerPainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  var endCallback;

  TimerPainterLiner(
      {this.animation, this.backgroundColor, this.color, this.endCallback})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    paint.color = color;
    // double progress = (1.0 - animation.value) * 2 * PI;
    if (0 == state) {
      print("unstart");
      return;
    }
    print("travelModel.list= ${currentTravelModel.list.length}");
    currentTime = new DateTime.now().millisecondsSinceEpoch;
    double distance = (currentTime - startDateTime) / 1000 * 5;
    double diff = (currentTime - lastDateTime) / 1000 * 5;

    print("diff= ${diff}|${state}");
    switch (state) {
      case 1:
        currentLineModel.end = new Offset(distance, 0);
        break;
      case 2:
        currentLineModel.end = new Offset(distance, -diff);
        lastDy = diff;
        break;
      case 3:
        currentLineModel.end = new Offset(distance, -lastDy + diff);
        break;
      case 4:
        currentLineModel.end = new Offset(distance, 0);
        break;
    }

    for (LineModel model in currentTravelModel.list) {
      canvas.drawLine(model.start, model.end, paint);
    }
    if ((2 == state || 3 == state) && 50 < diff) {
      endCallback();
    }
    if (1 == state && 299 < distance) {
      endCallback();
    }
  }

  @override
  bool shouldRepaint(TimerPainterLiner old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class PainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  final TravelModel travelModel;

  PainterLiner(
      {this.animation, this.backgroundColor, this.color, this.travelModel})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    paint.color = color;
    if (null == travelModel) {
      print("travelModel is null!");
      return;
    }
    for (LineModel model in this.travelModel.list) {
      canvas.drawLine(model.start, model.end, paint);
    }
  }

  @override
  bool shouldRepaint(PainterLiner old) {
//    return animation.value != old.animation.value ||
//        color != old.color ||
//        backgroundColor != old.backgroundColor;
    return true;
  }
}
