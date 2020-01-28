import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationRoute extends StatefulWidget {
  @override
  AnimationRouteState createState() => AnimationRouteState();
}

class AnimationRouteState extends State<AnimationRoute> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    // Controller设置动画时长
    // vsync设置一个TickerProvider，当前State 混合了SingleTickerProviderStateMixin就是一个TickerProvider
    controller = AnimationController(
        duration: Duration(seconds: 5),
        vsync: this //
    );
    // 设置动画曲线，开始快慢，先加速后减速
    animation=CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    // Tween设置动画的区间值，animate()方法传入一个Animation，AnimationController继承Animation
    animation = new Tween(begin: 100.0, end: 500.0).animate(animation)
    // addListener监听动画每一帧的回调，这个调用setState()刷新UI
      ..addListener(() {
        setState(()=>{});
      });
    //启动动画(正向执行)
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // 这里显示一个方形区域，随着动画执行不断变大
      child: Container(
        color: Colors.green,
        width: animation.value,
        height: animation.value,
      ),
    );
  }

  @override
  void dispose() {
    // 释放资源
    controller.dispose();
    super.dispose();
  }
}
 
 