import 'dart:math';
import 'package:example/common/data.dart';
import 'package:example/common/train_travel.dart';
import 'package:example/model/line_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:flutter/material.dart';
import '../common/config.dart';
import 'check.dart';

int breath=-1;
//List<LineModel> lines=[];
//Offset lastOffset =new Offset(0, 0);
TravelModel travelModel= new TravelModel();
LineModel lineModel;
int state =0;

class TrainPage extends StatefulWidget {
  TrainPage({this.bg});

  String bg;

  @override
  _TrainPageState createState() => _TrainPageState(bg: this.bg);
}

class _TrainPageState extends State<TrainPage>  with TickerProviderStateMixin {
  _TrainPageState({this.bg});
  AnimationController animationController;


//  double rate;
//  String resultTip;
  double lastTime = 0;
  double spentTime = 0;
  String commandText="开始";
  //int state=0;

  String bg;
  double width = 500;
  double height = 100;



  @override
  Widget build(BuildContext context) {
    print(bg);
    return Scaffold(
//      appBar: AppBar(
//        title: Text('bg'),
//      ),
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
              //1.空站位
              width: width,
              height: 50,
             // color: Colors.black12,
              child: Row(children: <Widget>[
                       Container(
                         width: 10,
                         height: 50,
                       ),
                      Text(
                        "晚上好 12:12",
                     style: new TextStyle(
                     color: Colors.white,
                     fontSize: 20.0,)
                   ),
                Container(
                  width: 200,
                  height: 50,
                ),
                new CircleAvatar(
                  radius: 15.0,
                  backgroundImage: AssetImage("assets/images/bg3.jpg"),
                )
              ])
            ),
            Container(
              //tips
              width: width,
              height: 100,
             // color: Colors.black12,
              child:
              Text(
                  sentenceList[Random().nextInt(sentenceList.length)].content,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),),
            ),
            Container(
              //1.训练1
              width: width,
              height: 50,
            //  color: Colors.black12,
//              child:  Expanded(
              child:  Align(
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
                ),),
              ),
            ),
            Container(
              //2.1.训练2
              width: width,
              height: 50,
              //  color: Colors.black12,
              child: Text(''),
            ),
            Container(
              //2.1.训练3
              width: width,
              height: 50,
              //  color: Colors.black12,
              child: Text(''),
            ),
            Container(
              //2.1.训练4
              width: width,
              height: 50,
              //  color: Colors.black12,
              child: Text(''),
            ),
//            Container(
//              //2.1.训练5
//              width: width,
//              height: 50,
//              //  color: Colors.black12,
//              child: Text(''),
//            ),
//            Container(
//              //3.tips
//              width: width,
//              height: 100,
//             // color: Colors.black12,
//              child: Text(''),
//            ),
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
            Container(
              //5.站位
              width: width,
              height: 30,
             // color: Colors.black12,
              // child: Text('Container固定宽高'),
            ),
            Container(
              //5.分割线
              width: width,
              height: 2,
             // color: Colors.grey[200],
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200], width: 1.0)),
              ),
            ),

            // Divider(height: 50.0,indent: 0.0,color: Colors.red,),
            Container(
              //4.中间站位
              width: width,
              height: 30,
             // color: Colors.black12,
            ),
            menuTap(),
            Container(
              //5.底部站位
              width: width,
              height: 20,
              //color: Colors.black12,
              // child: Text('Container固定宽高'),
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
  Widget menuTap() {
    return new Container(
      // tap选项卡
      width: width,
      height: 100,
      color: Colors.black12,
      child: Row(children: <Widget>[
        Container(
          width: 20,
          height: 100,
        ),
        Container(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg4.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  "3分钟练习",
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              )),
        ),
        Container(
          width: 20,
          height: 100,
        ),
        Container(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg3.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  "5分钟放松",
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              )),
        ),
        Container(
          width: 20,
          height: 100,
        ),
        Container(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  "10分钟入睡",
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              )),
        ),
      ]),
    );
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
        spentTime = lastTime - now;
        //state=0;
      } else {
        animationController.reverse(
            from: animationController.value == 0.0
                ? 1.0
                : animationController.value);
        spentTime = 0;
      //  state=1;
      }
      print(
          "current:$lastTime|$now|$spentTime|${animationController.value}");
      lastTime = animationController.duration.inSeconds *
          animationController.value;
      state = 1;
      Offset lastPoint= new Offset(0.0, 0.0);
      Offset currentPoint= new Offset(0.0, 0.0);
      lineModel = new LineModel(start:lastPoint,end:currentPoint);
      travelModel.list.add(lineModel);

      LineModel model= TrainTravel.createLiner(state);
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

   // canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * PI;
//    canvas.drawArc(
//        new Offset(36, 36) & size * 0.8, PI * 1.5, progress, false, paint);

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
    if(0==state){
      print("unstart");
      return ;
    }
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