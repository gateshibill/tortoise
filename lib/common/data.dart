import 'dart:async';

import 'package:example/model/topic_model.dart';
import 'package:example/model/travel_model.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

String latestVersion;

List<TopicModel> topicList=[];
List<TopicModel> sentenceList=[];
List<TopicModel> multiList=[];
List<TopicModel> relaxMusicList=[];

List <TravelModel> checkBreathTravelList=[];

List <TravelModel> exerciseTravelList=[];

String command = '播放';
bool isPlay = false;
IjkMediaController mediaController = IjkMediaController();
IjkMediaController audioController = IjkMediaController();
List <String> musicList=["assets/music/naturespath.mp3","assets/music/seawave.mp3","assets/music/fish.mp3","assets/music/bg1.mp3"];
int currentMusicIndex=0;

class Msg {
  static final SUCCESS = "0";
  String code;
  String desc;
  Object object;
}


