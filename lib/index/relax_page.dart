import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:example/common/data.dart';
import 'package:flutter/material.dart';


class RelaxPage extends StatefulWidget {
  @override
  _RelaxPageState createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> {
  String command = '播放';
  bool isPlay=false;

  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    //print(bg);
    return Scaffold(
      appBar: AppBar(
        title: Text('bg'),
      ),
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
            CircleAvatar(
              radius: 70.0,
              // backgroundImage: AssetImage("assets/images/bg3.jpg"),
              backgroundColor: Colors.blueGrey,
              child: RaisedButton(
                  child: Text(command,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  color: Colors.brown,
                  textColor: Colors.white,
                  elevation: 100,
                  shape: CircleBorder(),
                  onPressed: () {
                    startButton();
                  }),
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

  void startButton() async{
    print("startButton()");

    int result=0;
    if(!isPlay){
      isPlay= false;
      command="暂停";
       result = await audioPlayer.play("http://m7.music.126.net/20200201192943/fadd7e3393498349630c30373b6942fe/ymusic/3b40/64da/93f0/4caaf39e3d865da3e205328e5bf3e131.mp3");
    }else{
      isPlay= true;
      command="播放";
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
