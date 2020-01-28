import 'dart:math';

import 'package:example/common/data.dart';
import 'package:flutter/material.dart';
import './spread_widget.dart';

class RelaxPage extends StatefulWidget {
  RelaxPage({this.bg});
  String bg;
  @override
  _RelaxPageState createState() => _RelaxPageState(bg:this.bg);
}

class _RelaxPageState extends State<RelaxPage> {
  _RelaxPageState({this.bg});
  String bg;
  @override
  Widget build(BuildContext context) {
    print(bg);
    return Scaffold(
      appBar: AppBar(
        title: Text('bg'),
      ),
//      body: Center(
//          child: Image.asset(
//            bg,
//            fit: BoxFit.cover,
//          ),
//        ),
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
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                      //  child: Text("凌波不过横塘路，但目送、芳尘去。锦瑟华年谁与度？")
                    child: Text(multiList[Random().nextInt(multiList.length)].content)
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
