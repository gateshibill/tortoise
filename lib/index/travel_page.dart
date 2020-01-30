import 'dart:math';
import 'package:example/common/data.dart';
import 'package:example/common/train_travel.dart';
import 'package:example/model/line_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:flutter/material.dart';
import '../common/config.dart';
import 'check.dart';

int breath=-1;
TravelModel travelModel= new TravelModel();
LineModel lineModel;
int state =0;

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>  with TickerProviderStateMixin {
  _TravelPageState();
  AnimationController animationController;
  String bg="assets/images/bg5.jpg";
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
            Container(
              width: 200,
              height: 20,
            ),
            Container(
              //1.训练1
              width: width,
              height: 50,
              alignment: Alignment.bottomLeft,
              child:  Align(
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
                                  color: Theme.of(context).accentColor),
                            );
                          },
                        ),
                      ),
                    ],
                  ),),
              ),
            ),
            //屏息切换
            Container(//屏息切换
              //4.按钮
              width: 500,
              height: 40,
              alignment: Alignment.bottomLeft,
              //color: Colors.black12,
              child: RaisedButton(
                  child: Text('开始屏息'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    startButton();
                  }),
            ),
            //呼吸切换
            Container(
              //4.按钮
              width: 500,
              height: 40,
              alignment: Alignment.bottomLeft,
              //color: Colors.black12,
              child: RaisedButton(
                  child: Text('自由呼吸'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    breathButton();
                  }),
            ),
            //呼吸切换
            Container(
              //4.结束
              width: 500,
              height: 40,
              alignment: Alignment.bottomLeft,
              //color: Colors.black12,
              child: RaisedButton(
                  child: Text('结束'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    endButton();
                  }),
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
  void startButton() {
    print("startButton()");
    state=1;
    setState(() {
      print("animationController:${animationController.isAnimating}");
      double now = animationController.duration.inSeconds *
          animationController.value;
      if (animationController.isAnimating) {
        animationController.stop();
     //   spentTime = lastTime - now;
        //state=0;
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
      //  spentTime = 0;
      //  state=1;
      }

      state = 1;
      Offset lastPoint= new Offset(0.0, 0.0);
      Offset currentPoint= new Offset(0.0, 0.0);
      lineModel = new LineModel(start:lastPoint,end:currentPoint);
     // lineModel.start=lastPoint;
     // lineModel.end=currentPoint;
      travelModel.list.clear();
      travelModel.addLineModel(lineModel);

     // LineModel model= TrainTravel.createLiner(state);
    });
  }
  void breathButton() {
    setState(() {
      breath=1==breath?0:1;
      if(1==breath){
        state = 2;
        LineModel model= TrainTravel.createLiner(state);
        travelModel.addLineModel(model);
      }else{
        state = 3;
        LineModel model= TrainTravel.createLiner(state);
        travelModel.addLineModel(model);
      }
    });
  }
  void endButton() {
    print("endButton()");
    setState(() {
     state = 0;
     animationController.reset();
     LineModel model= TrainTravel.createLiner(state);
     travelModel.addLineModel(model);
     travelList.add(travelModel);
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

class TimerPainterLiner extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainterLiner({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * PI;
    if(0==state){
      print("unstart");
      return ;
    }
    print("travelModel.list= ${travelModel.list.length}");
    lineModel.end= new Offset(progress*50,0);
    for(LineModel model in travelModel.list){
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