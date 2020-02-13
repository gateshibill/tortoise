import 'dart:async';
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
String command = '开始';

class TrainPage extends StatefulWidget {
  bool isback = false;

  TrainPage([isback = false]) {
    this.isback = isback;
  }

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> with TickerProviderStateMixin {
  _TrainPageState();

  AnimationController animationController;
  String bg = "assets/images/bg13.jpg";
  double width = 500;
  double height = 100;
  String guideTip = "";

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
              " 呼吸训练",
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
              child: indicator(),
            ),
            Container(
              width: width,
              height: 50,
            ),
            Container(
              //1.训练1
              width: 350,
              height: 100,
              alignment: Alignment.center,
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
                                  switchCallback: startButton,
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
                                    0 == state ? "" : timerString,
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
            0 != state
                ? guideContainer()
                : RaisedButton(
                    child: Text(command),
                    color: Colors.brown,
                    textColor: Colors.white,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      startButton();
                    }),
            //呼吸切换
//            Container(
//              //4.结束
//              padding: const EdgeInsets.only(top: 10.0),
//              width: 100,
//              height: 10,
//              // alignment: Alignment.bottomLeft,
//              //color: Colors.black12,
//              child: 0==state?Container():RaisedButton(
//                  child: Text('结束'),
//                  color: Colors.brown,
//                  textColor: Colors.white,
//                  elevation: 20,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(15)),
//                  onPressed: () {
//                    endButton();
//                  }),
//            ),
            Container(
              //4.中间站位
              width: width,
              height: 30,
              // color: Colors.black12,
            ),
            //分割线
            checkBreathTravelList.length > 0
                ? Container(
                    //5.分割线
                    width: width,
                    height: 2,
                    // color: Colors.grey[200],
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0)),
                    ),
                  )
                : Container(),
            Container(
              //4.中间站位
              width: width,
              height: 10,
              // color: Colors.black12,
            ),
            Container(
                height: 50,
                child: Text(getEncourageTips(),
                  style: Theme.of(context).textTheme.subtitle,
                )),
            Container(
              //历史1
              width: width,
              height: 50,
              alignment: Alignment.centerLeft,
              child: getItem(null, checkBreathTravelList.length - 1),
            ),
            Container(
              //历史2
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, checkBreathTravelList.length - 2),
            ),
            Container(
              //历史3
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, checkBreathTravelList.length - 3),
            ),
            Container(
              //历史4
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, checkBreathTravelList.length - 4),
            ),
            Container(
              //历史e5
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, checkBreathTravelList.length - 5),
            ),
            Container(
                height: 50,
                child: Text(
                  sentenceList[Random().nextInt(sentenceList.length)].content,
                  style: Theme.of(context).textTheme.subhead,
                )),
          ],
        ),
      ),
    );
  }

  String getEncourageTips() {
    String tips = "";
    if (checkBreathTravelList.length < 5 &&
        checkBreathTravelList.length > 0 &&
        0 == state) {
      tips = "您已经完成了${checkBreathTravelList.length}次练习，很棒，请点击开始继续！";
    } else if (checkBreathTravelList.length >= 5&&
        0 == state) {
      tips = "您已经完成了${checkBreathTravelList.length}次练习，太棒了，休息一下！";
    } else if(0==checkBreathTravelList.length&&0==state){
      tips = "您还未练习，请点击开始进行呼吸练习吧！";
    }

    return tips;
  }

  Widget guideContainer() {
    return new Container(
      child: Text(guideTip, //
          maxLines: 6, //最大行数
          overflow: TextOverflow.ellipsis, //超出显示省略号
          style: new TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            //  background: Paint()..color = Colors.white,
          )),
    );
  }

  Widget indicator() {
    return new Text(
      trainTip, //
      maxLines: 6, //最大行数
      overflow: TextOverflow.ellipsis, //超出显示省略号
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 22.0,
        //  background: Paint()..color = Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 90));
  }

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${(90 - duration.inSeconds).toString().padLeft(2, '0')}';
  }

  Widget history() {
    print("history() travelList.length=${exerciseTravelList.length}");
    int length = exerciseTravelList.length;
    return ListView.builder(
      //  scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return getItem(context, length - index - 1);
      },
      itemCount: exerciseTravelList.length,
    );
  }

  Widget getItem(BuildContext context, int index) {
    //  print("getItem() index=${index}");
    if (index < 0) {
      return new Text("");
    }
    TravelModel model = checkBreathTravelList[index];
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
    // setState(() {
    print("animationController:${animationController.isAnimating}");
    double now =
        animationController.duration.inSeconds * animationController.value;
    if (animationController.isAnimating) {
      // animationController.stop();
      //   spentTime = lastTime - now;
      //state=0;
      // print("animationController:isAnimating");
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
        guideTip = '屏息...';
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
        guideTip = '吸气...';
        breathButton();
        break;
      case 2:
        state = 3;
        command = '吸气';
        guideTip = '呼气...';
        breathButton();
        break;
      case 3:
        state = 2;
        command = '呼气';
        guideTip = '吸气...';
        breathButton();
        break;
      case 4:
        guideTip = '放松...';
        break;
    }
    if (command.startsWith("放松")) {
      setState(() {
        guideTip = '放松...';
      });
    }
    if (guideTip.startsWith("屏息")) {
      setState(() {});
    }
  }

  void breathButton() {
    setState(() {
      breath = 1 == breath ? 0 : 1;

      LineModel model = currentLineModel.copy();
      currentTravelModel.addLineModel(model);
      currentLineModel.start = currentLineModel.end;
      lastDateTime = new DateTime.now().millisecondsSinceEpoch;
    });
  }

  void endButton() {
    print("endButton()");
    if (0 == state) {
      return;
    }
    try {
      setState(() {
        state = 0;
        command = '开始';
        animationController.reset();
        //LineModel model = TrainTravel.createLiner(state);
        currentTravelModel.addLineModel(currentLineModel.copy());
        checkBreathTravelList.add(currentTravelModel.copy());
        print("endButton() setState");
      });
    }catch(e){
      print(e.toString());
    }
  }

  void clearButton() {
    setState(() {
      animationController.reset();
      checkBreathTravelList.clear();
    });
  }

  @override
  void dispose() {
    // 释放资源
    endButton();
    animationController.dispose();
    super.dispose();
  }
}

class TimerPainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  var endCallback;
  var switchCallback;

  TimerPainterLiner(
      {this.animation,
      this.backgroundColor,
      this.color,
      this.switchCallback,
      this.endCallback})
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
    //print("travelModel.list= ${currentTravelModel.list.length}");
    currentTime = new DateTime.now().millisecondsSinceEpoch;
    double time = (currentTime - startDateTime) / 1000;
    double distance = time * 5;
    double diff = (currentTime - lastDateTime) / 1000 * 5;

    // print("diff= ${diff}|${state}");
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
    if ((2 == state || 3 == state) && 20 < diff) {
      // Timer timer = new Timer(new Duration(seconds: 0), () {
      endCallback();
      // });
      //  print("2 == state || 3 == state) && 50 < diff");
      return;
    }
    // print("before 310 < distance=${distance}");
    if (360 < distance) {
      print("360 distance");
      new Timer(new Duration(seconds: 0), () {
        endCallback();
      });
    } else if (306 < distance) {
      print("306 distance state=$state");
      command = '放松';
      if (4 != state) {
        new Timer(new Duration(seconds: 0), () {
          print("switchCallback()");
          switchCallback(); //会频繁刷
        });
      }
      state = 4;
    } else {
      if (time > 19) {
        int splus = (time - 19).toInt();
        int m = splus ~/ 3;
        int n = m % 2;
        if (0 == n && 2 != state) {
          //吸气
          Timer timer = new Timer(new Duration(seconds: 0), () {
            switchCallback();
          });
        } else if (1 == n && 2 == state) {
          //呼气
          Timer timer = new Timer(new Duration(seconds: 0), () {
            switchCallback();
          });
        }
      }
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
