import 'package:example/index/guide_page.dart';
import 'package:example/index/home_page.dart';
import 'package:example/index/relax_page.dart';
import 'package:example/index/exercise_page.dart';
import 'package:example/index/train_page.dart';
import 'package:flutter/material.dart';

import 'breath_page.dart';
import 'check_page.dart';
import '../pages/spread_page.dart';

//void main() => runApp(MyApp());

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      showPerformanceOverlay: false,
      theme: ThemeData(
        primaryColor: const Color(0xff262545),
        primaryColorDark: const Color(0xff201f39),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'fl_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            GuidePage(),
            HomePage(),
            CheckPage(),
            TrainPage(),
            BreathPage(),
             RelaxPage(),
           ExercisePage()
          ],
        controller:  PageController(initialPage: 1) ,
        ),
      ),
    );
  }
}
