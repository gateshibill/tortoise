import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:example/service/local_storage.dart';
import 'package:example/utils/log_util.dart';
import '../common/config.dart';
import '../common/data.dart';
import '../model/topic_model.dart';

class HttpClient {
  static final String TAG = "HttpClient";
  static final String token = "client_token";

  static Future<bool> init() async {
    getTopics().then((onValue){
      if(onValue.length>0){
        topicList=onValue;
        topicList.forEach((f){
          LocalStorage.setTopicModel(f);
        });
      }
    });
    return true;
  }

  //获取关注公众号文章
  static Future<List<TopicModel>> getTopics(
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${GET_TOPICS_URL}page=${page}&limit=${limit}";
    LogMyUtil.v("$TAG getTopics() url:$url");
    List<TopicModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      // LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        TopicModelList modelList = TopicModelList.fromJson(list);
        resultList = modelList.topicModelList;
        resultList.forEach((topic) {
          if (1 == topic.type) {
            sentenceList.add(topic);
          }else if(0 == topic.type){
            multiList.add(topic);
          }else if(2 == topic.type){
            relaxMusicList.add(topic);
          }
        });
      } else {
        String msg = parsed["msg"];
        LogMyUtil.e("$TAG msg:$msg");
      }
    } catch (e) {
      LogMyUtil.e("$TAG fail to getFollowOfficialAccountTopics() |$e");
    }
    return resultList;
  }
  static Dio getDio([String token = null]) {
    var dio = new Dio();
    dio.options.baseUrl = BASE_SERVER_URL;
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout = 6000;
    dio.options.headers["token"] = token;
    return dio;
  }
}
