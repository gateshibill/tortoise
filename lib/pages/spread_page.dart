import 'package:flutter/material.dart';
import 'spread_widget.dart';

class SpreadPage extends StatefulWidget {
  @override
  _SpreadPageState createState() => _SpreadPageState();
}

class _SpreadPageState extends State<SpreadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('放松呼吸'),
      ),
      body: Center(
        child: SpreadWidget(
          radius: 120,
          maxRadius: 350,
//          child: Image.asset(
//            'assets/game3.jpg',
//            fit: BoxFit.cover,
//          ),
        ),
      ),
    );
  }
}
