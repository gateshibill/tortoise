import 'dart:math';
import 'package:example/common/data.dart';
import 'package:example/common/widget_common.dart';
import 'package:example/model/breath_model.dart';
import 'package:example/model/line_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:example/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import '../common/config.dart';

int breath = -1;

int state = 0;
int type = 0;
int startDateTime = new DateTime.now().millisecondsSinceEpoch;
int lastDateTime = new DateTime.now().millisecondsSinceEpoch;
int currentTime;
double lastDy;
String command = '开始';
int breathTime = 0; //呼吸次数
int strongBreathTime = 0; //强力呼吸次数

double dx = 0;
double dy = 0;
double dz = 0;

double ds = 0;
double dt = 0;

double drpos = 0; //正点
double drsplus = 0; //负点
double drmax = 0;
double drmin = 0;
int isbreath = 0;
BreathModel inhaleBreathModel;
BreathModel exhaleBreathModel;
BreathModel lastBreathModel;

Offset lastPoint_x = new Offset(0, 0);
Offset lastPoint_y = new Offset(0, 0);
Offset lastPoint_z = new Offset(0, 0);
Offset lastPoint_s = new Offset(0, 0);
Offset lastPoint_t = new Offset(0, 0);
Offset lastPoint_r = null;

LineModel currentLineModel_x =
    new LineModel(start: lastPoint_x, end: lastPoint_x);
LineModel currentLineModel_y =
    new LineModel(start: lastPoint_y, end: lastPoint_y);
LineModel currentLineModel_z =
    new LineModel(start: lastPoint_z, end: lastPoint_z);
LineModel currentLineModel_s =
    new LineModel(start: lastPoint_z, end: lastPoint_z);
LineModel currentLineModel_t =
    new LineModel(start: lastPoint_z, end: lastPoint_z);
LineModel currentLineModel_r =
    new LineModel(start: lastPoint_z, end: lastPoint_z);
TravelModel currentTravelModel_x = new TravelModel();
TravelModel currentTravelModel_y = new TravelModel();
TravelModel currentTravelModel_z = new TravelModel();
TravelModel currentTravelModel_s = new TravelModel();
TravelModel currentTravelModel_t = new TravelModel();
TravelModel currentTravelModel_r = new TravelModel();

class BreathPage extends StatefulWidget {
  bool isback = false;

  BreathPage([isback = false]) {
    this.isback = isback;
  }

  @override
  _BreathPageState createState() => _BreathPageState();
}

class _BreathPageState extends State<BreathPage> with TickerProviderStateMixin {
  _BreathPageState();

  final String tag = "BreathPage";

  AnimationController animationController_x;
  AnimationController animationController_y;
  AnimationController animationController_z;
  AnimationController animationController_s;
  AnimationController animationController_t;
  AnimationController animationController_r;

  String bg = "assets/images/bg10.jpg";
  double width = 500;
  double height = 100;
  final int time = 60;
  String resultString = "";
  TextEditingController maxController;
  TextEditingController minController;

  String max;
  String min;

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
              "呼吸测试",
            ),
            Container(
              width: 200,
              height: 20,
            ),
            Container(
                //1.空站位
                width: width,
                height: 0,
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
              height: 20,
            ),
            //x方向
            Container(
              //1.训练1
              width: width,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController_x,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainterLiner(
                                  animation: animationController_x,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor,
                                  endCallback: endButton,
                                  point: dx,
                                  lastPoint: lastPoint_x,
                                  lineModel: currentLineModel_x,
                                  travelModel: currentTravelModel_x,
                                  type: 1),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // y方向
            Container(
              //1.训练1
              width: width,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController_y,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainterLiner(
                                    animation: animationController_y,
                                    backgroundColor: Colors.white,
                                    color: Theme.of(context).accentColor,
                                    endCallback: endButton,
                                    point: dy,
                                    lastPoint: lastPoint_y,
                                    lineModel: currentLineModel_y,
                                    travelModel: currentTravelModel_y,
                                    type: 2));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Z方向
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
                          animation: animationController_z,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainterLiner(
                                  animation: animationController_z,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor,
                                  endCallback: endButton,
                                  point: dz,
                                  lastPoint: lastPoint_z,
                                  lineModel: currentLineModel_z,
                                  travelModel: currentTravelModel_z,
                                  type: 3),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //S
            Container(
              //ds
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
                          animation: animationController_s,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainterLiner(
                                  animation: animationController_s,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor,
                                  endCallback: endButton,
                                  point: ds,
                                  lastPoint: lastPoint_s,
                                  lineModel: currentLineModel_s,
                                  travelModel: currentTravelModel_s,
                                  type: 4),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //结果线
            Container(
              //dt
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
                          animation: animationController_r,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainterLiner(
                                  animation: animationController_r,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).accentColor,
                                  endCallback: endButton,
                                  point: drpos,
                                  lastPoint: lastPoint_r,
                                  lineModel: currentLineModel_r,
                                  travelModel: currentTravelModel_r,
                                  type: 6),
                            );
                          },
                        ),
                      ),
                      Align(
                        // alignment: FractionalOffset.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                                animation: animationController_z,
                                builder: (_, Widget child) {
                                  return Text(
                                    timerString,
                                    style: Theme.of(context).textTheme.subtitle,
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(children: <Widget>[
              Container(
                width: 50,
                  child:TextField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly
                ], //只允许输入数字
                decoration: InputDecoration(
                  hintText: 'max',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[300],
                  ),
                ),
                controller: this.minController,
                onChanged: (value) {
                  this.setState(() {
                    this.minController.text = value;
                  });
                },
              )),
              Container(
                width: 50,
              ),
              RaisedButton(
                  child: Text(command),
                  color: Colors.brown,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    startButton();
                  }),
              Container(
                width: 50,
              ),
//              Container(
//                  width: 50,
//                  child:TextField(
//                    inputFormatters: [
//                      WhitelistingTextInputFormatter.digitsOnly
//                    ], //只允许输入数字
//                    decoration: InputDecoration(
//                      hintText: 'min',
//                      hintStyle: TextStyle(
//                        fontSize: 12,
//                        color: Colors.grey[300],
//                      ),
//                    ),
//                    controller: this.minController,
//                    onChanged: (value) {
//                      this.setState(() {
//                        this.minController.text = value;
//                      });
//                    },
//                  )),
            ]),
            //屏息切换按钮

            Container(
              //4.中间站位
              width: width,
              height: 10,
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
            //占位用
            Container(
              //4.中间站位
              width: width,
              height: 10,
              // color: Colors.black12,
            ),
            //呼吸结果
            Container(
                height: 30,
                child: Text(
                  resultString,
                  style: Theme.of(context).textTheme.subtitle,
                )),
            Container(
              //4.中间站位
              width: width,
              height: 10,
              // color: Colors.black12,
            ),
            Container(
              //历史1
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, exerciseTravelList.length - 1),
            ),
            Container(
              //历史2
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, exerciseTravelList.length - 2),
            ),
            Container(
              //历史3
              width: width,
              height: 50,
              //alignment: Alignment.bottomLeft,
              child: getItem(null, exerciseTravelList.length - 3),
            ),
            !widget.isback
                ? Container(
                    height: 50,
                  )
                : Container(
                    child: RaisedButton(
                    //按钮
                    child: Text('返回首页'),
                    color: Colors.brown,
                    textColor: Colors.white,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      //相应按钮点击事件
                      // 通过MaterialPageRoute跳转逻辑 的具体执行
                      Navigator.pop(context);
                    },
                  )),
          ],
        ),
      ),
    );
  }

  Widget indicator() {
    return new Text(
      checkBreathTip, //
      maxLines: 6, //最大行数
      overflow: TextOverflow.ellipsis, //超出显示省略号
      style: new TextStyle(
        color: Colors.cyan,
        fontSize: 22.0,
        //  background: Paint()..color = Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController_x =
        AnimationController(vsync: this, duration: Duration(seconds: time));
    animationController_y =
        AnimationController(vsync: this, duration: Duration(seconds: time));
    animationController_z =
        AnimationController(vsync: this, duration: Duration(seconds: time));
    animationController_s =
        AnimationController(vsync: this, duration: Duration(seconds: time));
    animationController_t =
        AnimationController(vsync: this, duration: Duration(seconds: time));

    animationController_r =
        AnimationController(vsync: this, duration: Duration(seconds: time));
  }

  String get timerString {
    Duration duration =
        animationController_z.duration * animationController_z.value;
    return '${duration.inMinutes}:${(60 - (duration.inSeconds % 60)).toString().padLeft(2, '0')}';
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
    print("getItem() index=${index}");
    if (index < 0) {
      return new Text("");
    }
    TravelModel model = exerciseTravelList[index];
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
                animation: animationController_z,
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
    setState(() {
      if (command == "结束") {
        endButton();
        return;
      } else {
        command = "结束";
        breathTime = 0;
        strongBreathTime = 0;
        state = 1;
        acceleromete();
        lastPoint_x = new Offset(0, 0);
        lastPoint_y = new Offset(0, 0);
        lastPoint_z = new Offset(0, 0);
        lastPoint_s = new Offset(0, 0);
        lastPoint_t = new Offset(0, 0);

        currentTravelModel_x.list.clear();
        animationController_x.reset();
        currentTravelModel_y.list.clear();
        animationController_y.reset();
        currentTravelModel_z.list.clear();
        animationController_z.reset();
        currentTravelModel_s.list.clear();
        animationController_s.reset();
        currentTravelModel_t.list.clear();
        animationController_t.reset();
        currentTravelModel_r.list.clear();
        animationController_r.reset();

        startDateTime = new DateTime.now().millisecondsSinceEpoch;

        lastPoint_r = null;
        print("animationController:${animationController_z.isAnimating}");
        double now = animationController_z.duration.inSeconds *
            animationController_z.value;

        if (animationController_z.isAnimating) {
        } else {
          animationController_z.reverse(
              from: animationController_z.value == 0.0
                  ? 1.0
                  : animationController_z.value);

          animationController_x.reverse(
              from: animationController_x.value == 0.0
                  ? 1.0
                  : animationController_x.value);

          animationController_y.reverse(
              from: animationController_y.value == 0.0
                  ? 1.0
                  : animationController_y.value);

          animationController_s.reverse(
              from: animationController_s.value == 0.0
                  ? 1.0
                  : animationController_s.value);

          animationController_t.reverse(
              from: animationController_t.value == 0.0
                  ? 1.0
                  : animationController_t.value);

          animationController_r.reverse(
              from: animationController_r.value == 0.0
                  ? 1.0
                  : animationController_r.value);
        }
      }
    });
  }

  void endButton() {
    print("endButton()");
    try {
      setState(() {
        command = "开始";
        currentTravelModel_r.breathTime = breathTime;
//      exerciseTravelList.add(currentTravelModel_s.copy());
//      exerciseTravelList.add(currentTravelModel_z.copy());
//      exerciseTravelList.add(currentTravelModel_y.copy());
//      exerciseTravelList.add(currentTravelModel_x.copy());
        exerciseTravelList.add(currentTravelModel_r.copy());
        result(currentTravelModel_r.copy());
      });
    } catch (e) {
      LogMyUtil.e(e);
    }
    state = 0;
  }

  void result(TravelModel model) {
    String result = "一分钟呼吸次数$breathTime次,";
    LogMyUtil.e("result() $breathTime|${model.breathTime}");
    print("result() $breathTime|${model.breathTime}");
    if (model.breathTime > 15) {
      result += "呼吸偏快";
    } else if (model.breathTime < 6) {
      result += "呼吸慢";
    } else {
      result += "呼吸正常";
    }
    if (strongBreathTime / breathTime > 0.6) {
      result += "，呼吸幅度有点大!";
    }
    try {
      setState(() {
        resultString = result;
      });
    } catch (e) {
      LogMyUtil.e(e.toString());
    }
  }

  @override
  void dispose() {
    // 释放资源
    endButton();
    animationController_z.dispose();
    super.dispose();
  }
}

class TimerPainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  var endCallback;
  double point;
  Offset lastPoint;
  LineModel lineModel;
  TravelModel travelModel;
  int type;

  TimerPainterLiner(
      {this.animation,
      this.backgroundColor,
      this.color,
      this.endCallback,
      this.point,
      this.lastPoint,
      this.lineModel,
      this.travelModel,
      this.type})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    paint.color = color;

//    if (0 == state) {
//      return;
//    }

    //print("travelModel.list= ${currentTravelModel_z.list.length}");
    currentTime = new DateTime.now().millisecondsSinceEpoch;
    double distance = (currentTime - startDateTime) / 1000 * 6;

    print("distance=${distance}");
    if (distance > 359 && 0 != state) {
      playAudio("assets/audio/over.mp3");
      for (LineModel model in travelModel.list) {
        canvas.drawLine(model.start, model.end, paint);
      }
      state = 0;
      return;
    } else if (0 == state) {
      for (LineModel model in travelModel.list) {
        canvas.drawLine(model.start, model.end, paint);
      }
      return;
    }
    //double diff = (currentTime - lastDateTime) / 1000 * 5;
    // LogMyUtil.v("diff= ${point}|${state}");

    Offset currentPoint = new Offset(distance, point);
    switch (type) {
      case 1:
        currentLineModel_x =
            new LineModel(start: lastPoint_x, end: currentPoint);
        currentTravelModel_x.addLineModel(lineModel);
//        for (LineModel model in travelModel.list) {
//          canvas.drawLine(model.start, model.end, paint);
//        }
        lastPoint_x = currentPoint;
        break;
      case 2:
        currentLineModel_y =
            new LineModel(start: lastPoint_y, end: currentPoint);
        currentTravelModel_y.addLineModel(lineModel);
//        for (LineModel model in travelModel.list) {
//          canvas.drawLine(model.start, model.end, paint);
//        }
        lastPoint_y = currentPoint;
        break;
      case 3:
        currentLineModel_z =
            new LineModel(start: lastPoint_z, end: currentPoint);
        currentTravelModel_z.addLineModel(lineModel);
//        for (LineModel model in travelModel.list) {
//          canvas.drawLine(model.start, model.end, paint);
//        }
        lastPoint_z = currentPoint;
        break;
      case 4:
        currentLineModel_s =
            new LineModel(start: lastPoint_s, end: currentPoint);
        currentTravelModel_s.addLineModel(lineModel);
//        for (LineModel model in travelModel.list) {
//          canvas.drawLine(model.start, model.end, paint);
//        }
        lastPoint_s = currentPoint;
        //print("lastPoint_s.dy=${lastPoint_s.dy}");
        if (lastPoint_s.dy > 50) {
          ++strongBreathTime;
        }
        break;
      case 5:
        currentLineModel_t =
            new LineModel(start: lastPoint_t, end: currentPoint);
        currentTravelModel_t.addLineModel(lineModel);
//        for (LineModel model in travelModel.list) {
//          canvas.drawLine(model.start, model.end, paint);
//        }
        lastPoint_t = currentPoint;
        break;
      case 6: //呼吸线
        break;
    }
    for (LineModel model in travelModel.list) {
      canvas.drawLine(model.start, model.end, paint);
    }
  }

  @override
  bool shouldRepaint(TimerPainterLiner old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

void acceleromete() {
  int i = 0;
  userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    // LogMyUtil.v(event);
    if (0 == state) {
      return;
    }
    double max = 50;
    double min = 2;
    double breakPoint = 10;
    double breakPointDiff = 15;
    int scale = 6;
    int p = 600;
    dx = event.x * p;
    if (dx > max) {
      dx = max;
    } else if (dx < -max) {
      dx = -max;
    } else if (dx > -min && dx < min) {
      dx = 0;
    }

    dy = event.y * p;
    if (dy > max) {
      dy = max;
    } else if (dy < -max) {
      dy = -max;
    } else if (dy > -min && dy < min) {
      dy = 0;
    }

    dz = event.z * p;
    if (dz > max) {
      dz = max;
    } else if (dz < -max) {
      dz = -max;
    } else if (dz > -min && dz < min) {
      dz = 0;
    }

    ds = dx + dz;
    if (dx < min && dz < min || dx > -min && dz > -min) {
      dt = ds;
    } else {
      dt = 0;
    }


    //if (0 == i++ % 2) {
    if (0 == isbreath || 1 == isbreath) {
      //取吸点
      if (ds < -breakPoint) {
        //取正最高点，直到遇到负时停止，
        drsplus = ds;
        isbreath = 1;
      } else if (ds >= breakPoint && 1 == isbreath) {
        isbreath = 2; //取呼点
      }
    } else {
      if (ds > breakPoint) {
        drpos = ds;
        if(drpos-drsplus>breakPointDiff)
        isbreath = 3;
      } else if (3 == isbreath) {
        //说明找到分界点了
        isbreath = 0;
        currentTime = new DateTime.now().millisecondsSinceEpoch;
        double distance = (currentTime - startDateTime) / 1000 * 6;
        Offset currentPoint = new Offset(distance, -16);
        BreathModel currentBreathModel =
            new BreathModel(dateTime: new DateTime.now(), type: 1);
        currentBreathModel.x = distance;
        double interval = 3.0 * scale;
        if (null != lastBreathModel) {
          interval = (new DateTime.now().millisecondsSinceEpoch -
                  lastBreathModel.dateTime.millisecondsSinceEpoch) /
              1000 *
              scale;
          if (interval <= 6 * scale) {
            //默认3秒吸气时间
            interval = interval / 2;
          } else {
            interval = 3.0 * scale;
          }
        }
        //前面那个点需要完善
        double currentPoint_x = distance - interval;
        if (null != lastPoint_r) {
          double lastPoint_x = lastBreathModel.x + interval;

          Offset afterPoint = new Offset(lastPoint_x, 0);
          LineModel beforeLineModel =
              new LineModel(start: lastPoint_r, end: afterPoint);
          currentTravelModel_r.addLineModel(beforeLineModel.copy());

          if (currentPoint_x > lastPoint_x) {
            //屏息线
            LineModel levelLineModel = new LineModel(
                start: new Offset(lastPoint_x, 0),
                end: new Offset(currentPoint_x, 0));
            currentTravelModel_r.addLineModel(levelLineModel);
          }
        }

        Offset beforePoint = new Offset(currentPoint_x, -0);
        currentLineModel_r =
            new LineModel(start: beforePoint, end: currentPoint);
        currentTravelModel_r.addLineModel(currentLineModel_r.copy());
        lastPoint_r = currentPoint;
        lastBreathModel = currentBreathModel;

        if (0 != state) {
          ++breathTime;
          ++currentTravelModel_r.breathTime;
        }
      }
    }
    //   }
  });
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
      ..strokeWidth = 1.0
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
