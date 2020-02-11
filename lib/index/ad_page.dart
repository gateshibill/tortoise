import 'package:flutter/material.dart';
import '../pages/spread_widget.dart';

class AdPage extends StatefulWidget {
  AdPage({this.bg});
  String bg;
  @override
  _AdPageState createState() => _AdPageState(bg:this.bg);
}

class _AdPageState extends State<AdPage> {
  _AdPageState({this.bg});
  String bg;
  @override
  Widget build(BuildContext context) {
    print(bg);
    return Scaffold(
      appBar: AppBar(
        title: Text('bg'),
      ),
      body: Center(
          child: Image.asset(
            bg,
            fit: BoxFit.cover,
          ),
        ),
      //),
    );
  }
}
