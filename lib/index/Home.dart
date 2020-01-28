import 'dart:math';

import 'package:example/common/data.dart';
import 'package:flutter/material.dart';
import './spread_widget.dart';

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
              //1.空站位
              width: width,
              height: 50,
              color: Colors.black12,
              child: Text(DateTime.now().toUtc().toLocal().toString()),
            ),
            Container(
              //1.空站位
              width: width,
              height: 100,
              color: Colors.black12,
              child: Text( sentenceList[Random().nextInt(sentenceList.length)].content),
            ),
            Container(
              //2.标题
              width: width,
              height: 100,
              color: Colors.black12,
              child: Text('Container固定宽高'),
            ),
            Container(
              //3.tips
              width: width,
              height: 200,
              color: Colors.black12,
              child: Text('Container固定宽高'),
            ),
            Container(
              //4.中间站位
              width: width,
              height: 100,
              color: Colors.black12,
              child: Text('Container固定宽高'),
            ),
            Container(
              //5.分割线
              width: width,
              height: 2,
              color: Colors.grey[200],
                  child:DecoratedBox(
                    decoration:BoxDecoration(
                        border:Border.all(color: Colors.grey[200],width: 1.0)
                    ),
              ),
            ),

           // Divider(height: 50.0,indent: 0.0,color: Colors.red,),
            Container(
              //4.中间站位
              width: width,
              height: 50,
              color: Colors.black12,
            ),
            Container(
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
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/bg2.jpg",
                      image: "assets/images/bg3.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
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
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/bg3.jpg",
                      image: "assets/images/bg4.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
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
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/bg4.jpg",
                      image: "assets/images/bg5.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              //5.分割线
              width: width,
              height: 20,
              color: Colors.black12,
             // child: Text('Container固定宽高'),
            ),
          ],
        ),
      ),
    );
  }
}
