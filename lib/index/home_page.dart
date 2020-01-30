import 'dart:math';
import 'package:example/common/data.dart';
import 'package:flutter/material.dart';

import 'check.dart';
//import 'package:date_format/date_format.dart'

class HomePage extends StatefulWidget {
  HomePage({this.bg});

  String bg;

  @override
  _HomePageState createState() => _HomePageState(bg: this.bg);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({this.bg});

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
                          //DateFormat.DEFAULT.(DateTime.now(), ["yyyy"]).toString(),
                         // DateTime.now().toUtc().toLocal().toString(),
                     //  formatDate(new DateTime.now() ,[""]),
                       // formatDate(DateTime.now(), [yyyy, "年", mm, "月", dd]),
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
              //2.站位
              width: width,
              height: 100,
            //  color: Colors.black12,
              child: Text(''),
            ),
            Container(
              //3.tips
              width: width,
              height: 230,
             // color: Colors.black12,
              child: Text(''),
            ),
            Container(
              //4.按钮
              width: 500,
              height: 40,
              alignment: Alignment.bottomLeft,
              //color: Colors.black12,
              child: RaisedButton(
                  child: Text('BOLT测试'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    print("圆角按钮");
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Check();
                    }));
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
}