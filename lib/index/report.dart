import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//import 'pages/custom_column_nested_table.dart';
//import 'pages/custom_column_table.dart';
import '../pages/simple_table.dart';



class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Table Widget"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Simple Table",
              ),
//              Tab(
//                text: "Custom Table",
//              ),
//              Tab(
//                text: "Nested Data Table",
//              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SimpleTable(),
           // CustomColumnTable(),
          //  CustomColumnNestedTable(),
          ],
        ),
      ),
    );
  }
}
