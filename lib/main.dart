import 'dart:io';
import 'package:example/service/local_storage.dart';
import 'package:example/service/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './splash_page.dart';





void main() async {

  await startSplash();

  //saveSystemInfo();
  //p2pCheck();
}

Future startSplash() async {
//  runApp(BlocProvider<CounterBloc>(
//    bloc: CounterBloc(),
//    child: BlocProvider(child: APPStartup(), bloc: CounterBloc()),
//  ));
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(APPStartup());
}

class APPStartup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalStorage.init();
    HttpClient.init();
        return MaterialApp(
          //title: "p2play",
          // theme: ThemeData(backgroundColor: Colors.white),
//          theme: ThemeData(
//            primarySwatch: Colors.blue,
//          ),
          //theme: GlobalConfig.themeData,
          debugShowCheckedModeBanner: false,
          home: new SplashPage(),
        );
//      },
//    );
  }
}


