import 'package:example/scatter_chart/scatter_chart_page.dart';
import 'package:flutter/material.dart';


import 'index/ad_page.dart';
import 'index/exercise.dart';
import 'index/check.dart';
import 'index/relax_page.dart';
import 'index/spread_page.dart';

//void main() => runApp(MyApp());

class Home extends StatelessWidget {
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
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            Check(),
            Exercise(),
            SpreadPage(),
            RelaxPage(bg: "assets/images/bg2.jpg"),
            AdPage(bg: 'assets/images/bg3.jpg'),
            AdPage(bg: 'assets/images/bg4.jpg'),
            AdPage(bg: 'assets/images/bg5.jpg'),
          ],
        ),
      ),
    );
  }
}
