import 'dart:math';
import 'package:example/common/config.dart';
import 'package:example/common/data.dart';
import 'package:example/common/widget_common.dart';
import 'package:example/index/check_page.dart';
import 'package:example/index/exercise_page.dart';
import 'package:example/index/relax_page.dart';
import 'package:example/pages/spread_widget.dart';
import 'package:example/model/breath_model.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'breath_animation.dart';
import 'breath_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String bg;
  double width = 500;
  double height = 100;

  int type = 0;
  double lastPoint;
  double lastDiff;
  List<double> lastPointList = [];
  BreathModel model;
  List<double> afterChangePointList = [];
  int i = 0;
  bool breath = false;
  String command = "轻呼吸";
  static bool isShowTip = false;

  @override
  Widget build(BuildContext context) {
    // print(bg);
    return Scaffold(
//      appBar: AppBar(
//        title: Text('bg'),
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
                image: AssetImage('assets/images/bg7.jpg'),
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
                      Text("晚上好 12:12",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          )),
                      Container(
                        width: 120,
                        height: 50,
                      ),
                        RaisedButton(
                            child: Icon(Icons.music_note),
                            color: isPlay?Colors.blue:Colors.blueGrey,
                            //textColor: Colors.white,
                           // elevation: 10,
                            shape: CircleBorder(),
                            onPressed: () {
                              setState(() {
                                play();
                              });
                            }),
                      Container(
                        width: 1,
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 15.0,
                        backgroundImage: AssetImage("assets/images/bg3.jpg"),
                      )
                    ])),
                Container(
                  //3.tips
                  width: width,
                  height: 100,
                  // color: Colors.black12,
                  child: indicator(),
                ),
                BreathAnimation.isRun?Container(
                  //3.tips
                  width: width,
                  height: 410,
                  // color: Colors.black12,
                  child: BreathAnimation(
                    radius: 0,
                    maxRadius: 350,
                  ),
                ):Container(
                  height: 410,
                ),
                RaisedButton(
                    child: Text(command=BreathAnimation.isRun?"结束":"轻呼吸"),
                    color: Colors.brown,
                    textColor: Colors.white,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      setState(() {
                        if(BreathAnimation.isRun){
                         // command="轻呼吸";
                          BreathAnimation.isRun=false;
                        }else{
                          //command="结束";
                          BreathAnimation.isRun=true;
                        }
                      });
                    }),
                Container(
                  //5.站位
                  width: width,
                  height: 10,
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
                        border:
                            Border.all(color: Colors.grey[200], width: 1.0)),
                  ),
                ),

                // Divider(height: 50.0,indent: 0.0,color: Colors.red,),
                Container(
                  //4.中间站位
                  width: width,
                  height: 20,
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
          )),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 320, -400),
      floatingActionButton: guide(isShowTip),
    );
  }

  @override
  void initState() {
    super.initState();
    play();
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
    try {
      setState(() {
        isShowTip = true;
        print("isTip=true");
      });
    }catch(e){

    }
    if(isPlay){
      play();
    }
  }

  Widget indicator() {
    return new Text(
      breathTip, //
      maxLines: 6, //最大行数
      overflow: TextOverflow.ellipsis, //超出显示省略号
      style: new TextStyle(
        color: Colors.cyanAccent,
        fontSize: 22.0,
        //  background: Paint()..color = Colors.white,
      ),
    );
  }

  void counter(double point) {
    double currentDiff = point - lastPoint;
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new CheckPage(true);
                }));
              },
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
                      "BOLT测评",
                      style: new TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                    ),
                  )),
            )),
        Container(
          width: 20,
          height: 100,
        ),
        Container(
          width: 100,
          height: 100,
          child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new ExercisePage(true);
                }));
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg10.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      "呼吸训练",
                      style: new TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                    ),
                  ))),
        ),
        Container(
          width: 20,
          height: 100,
        ),
        Container(
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new BreathPage(true);
                }));
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg11.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      "呼吸测试",
                      style: new TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                    ),
                  )),
            )),
      ]),
    );
  }
}
