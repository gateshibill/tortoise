import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:example/common/data.dart';
import 'package:flutter/material.dart';

class RelaxPage extends StatefulWidget {
  @override
  _RelaxPageState createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> {
  double width = 500;
  String command = '播放';
  bool isPlay = false;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    //print(bg);
    return Scaffold(
//      appBar: AppBar(
//        title: Text('bg'),
//      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              //1.空站位
                width: width,
                height: 50,
                // color: Colors.black12,
                child: Row(children: <Widget>[
                  Container(
                    width: 10,
                    height: 50,
                  ),
                  Text("晚上好 12:12",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  Container(
                    width: 200,
                    height: 50,
                  ),
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage("assets/images/bg3.jpg"),
                  )
                ])),
//            Container(
//              //tips
//              width: width,
//              height: 100,
//              // color: Colors.black12,
//              child: Text(
//                sentenceList[Random().nextInt(sentenceList.length)].content,
//                style: new TextStyle(
//                  color: Colors.white,
//                  fontSize: 15.0,
//                ),
//              ),
//            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          //  child: Text("凌波不过横塘路，但目送、芳尘去。锦瑟华年谁与度？")
                          child: Text(
                              multiList[Random().nextInt(multiList.length)]
                                  .content)),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Text(""),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 40.0,
              // backgroundImage: AssetImage("assets/images/bg3.jpg"),
              backgroundColor: Colors.blueGrey,
              child: RaisedButton(
                  child: Text(command,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  color: Colors.transparent,
                  textColor: Colors.white,
                  elevation: 100,
                  shape: CircleBorder(),
                  onPressed: () {
                    startButton();
                  }),
            ),
            Container(
              width: 200,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startButton();
  }

  @override
  void dispose() {
    // 释放资源
    print('结束');
    audioPlayer.release();
    super.dispose();
  }

  void startButton() async {

    String url =
        "http://m7.music.126.net/20200201192943/fadd7e3393498349630c30373b6942fe/ymusic/3b40/64da/93f0/4caaf39e3d865da3e205328e5bf3e131.mp3";
    if (null != relaxMusicList && relaxMusicList.length > 0) {
      url = relaxMusicList[Random().nextInt(relaxMusicList.length)].url;
    }
    print("startButton()|$url");
    int result = 0;
    if (!isPlay) {
      isPlay = false;
      command = "暂停";
      result = await audioPlayer.play(url);
    } else {
      isPlay = true;
      command = "播放";
      result = await audioPlayer.pause();
    }

    if (result == 1) {
      print('play success');
    } else {
      print('play failed');
    }

    audioPlayer.onAudioPositionChanged.listen((p) async {
      print(p.inSeconds);
    });
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
      print('pause success');
    } else {
      print('pause failed');
    }
  }
}
