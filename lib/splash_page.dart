import 'dart:async';

import 'package:example/index/index.dart';
import 'package:flutter/material.dart';

//import 'index/index_page.dart';

//启动页面
class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPage createState() => new _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  bool isStartHomePage = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          goToHomePage();
        }, //设置页面点击事件
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/bg1.jpg",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 70),
                    child: Image.asset(
                      "assets/images/tortoise.png",
                      fit: BoxFit.cover,
                      height: 50.0,
                      width: 50.0,
                    ),
                  ) //
                  ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Copyright ©轻呼吸 版权所有",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          decoration: TextDecoration.none),
                    ),
                  )),
            ],
          ),
        ));
  }

  //页面初始化状态的方法
  @override
  void initState() {
    super.initState();
    //开启倒计时
    countDown();
  }

  void countDown() {
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 1);
    new Future.delayed(duration, goToHomePage);
  }

  void goToHomePage() {
    if (!isStartHomePage) {
      //跳转主页 且销毁当前页面
     // Navigator.of(context).pushAndRemoveUntil(newRoute, predicate);
      Navigator.of(context).pushAndRemoveUntil<dynamic >(
          MaterialPageRoute<dynamic>(builder: (context) => new Index()),
          (Route<dynamic> rout) => false);
      isStartHomePage = true;
    }
  }
}
