import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wechat/common/enum.dart';
import 'package:wechat/model/bulletin_model.dart';
import 'package:wechat/model/group_model.dart';
import 'package:wechat/model/official_account_model.dart';
import 'package:wechat/service/flutter_smack.dart';
import 'package:wechat/service/store_state.dart';
import 'package:wechat/service/tencent_cos.dart';

import '../common/config.dart';
import '../common/data.dart';
import '../model/topic_model.dart';
import '../model/user_model.dart';
import '../utils/log_util.dart';

class HttpClient {
  static final String TAG = "HttpClient";
  static final String token = "client_token";

  static Future<bool> init() async {}

  static Future<void> checkConnectServer() async {
    try {
      var dio = getDio(token);
      var response = await dio.get(CHECK_SERVER_URL);
      String res = response.data.toString();
      //LogUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("200" == code) {
        LogMyUtil.v("$TAG ConnectServerAvailabe");
        isConnectServerAvailable = true;
      } else {
        LogMyUtil.v("$TAG ConnectServerUnavailabe");
        isConnectServerAvailable = false;
      }
    } catch (e) {
      // LogUtil.v("$TAG fail to checkConnectServer()" + e.toString());
      isConnectServerAvailable = false;
      return null;
    }
  }

  //上传文件
  static Future<String> upload(String path, String jid, String urlStr) async {
    LogMyUtil.v("$TAG upload ${path}|$jid|$urlStr");
    MultipartFile mfile = await MultipartFile.fromFile(path, filename: jid);
    FormData formData = FormData.fromMap({"name": jid, "file": mfile});
    var dio = new Dio();
    dio.options.baseUrl = BASE_SERVER_URL;
    dio.options.connectTimeout = 100000; //100s
    dio.options.receiveTimeout = 60000; //60s
    dio.options.headers["token"] = token;
    String url = "";
    // dio.options.contentType = "application/x-www-form-urlencoded";
    var response = await dio.post(urlStr, data: formData);
    if (response.statusCode == 200) {
      LogMyUtil.v("$TAG response:${response.data}");
      final Map parsed = json.decode(response.data);
      //  final Map parsed1 = parsed["data"];
      url = parsed["objects"];
      LogMyUtil.v("$TAG url:${url}");
    } else {
      LogMyUtil.v("$TAG upload() 后端接口异常");
    }
    return url;
  }

  //上传普通文件
  static Future<String> uploadFile(String path, String jid) async {
    LogMyUtil.v("$TAG upload ${path}|$UPLOAD_URL");
    return await upload(path, jid, UPLOAD_URL);
  }

  //上传普通文件
  static Future<String> uploadFileToCloud(String path, String jid) async {
    LogMyUtil.v("$TAG upload ${path}|$UPLOAD_URL");
    return await UploadCloudUtils.uploadCloud(path, jid, UPLOAD_URL);
  }

  //上传用户头像
  static Future<String> uploadHeader(String path, String jid) async {
    LogMyUtil.v("$TAG upload ${path}|$UPLOAD_HEADER_URL");
    return await upload(path, jid, UPLOAD_HEADER_URL);
  }

  //上传用户头像
  static Future<String> uploadHeaderToCloud(String path, String jid) async {
    LogMyUtil.v("$TAG upload ${path}|$UPLOAD_HEADER_URL");
    return await UploadCloudUtils.uploadCloud(path, jid, UPLOAD_HEADER_URL);
  }

  //上传公众号头像
  static Future<String> uploadOfficialAccountHeader(
      String path, String jid) async {
    LogMyUtil.v(
        "$TAG uploadOfficialAccountHeader ${path}|$UPLOAD_OFFICIAL_ACCOUNT_HEADER_URL");
    return await upload(path, jid, UPLOAD_OFFICIAL_ACCOUNT_HEADER_URL);
  }

  //上传公众号头像
  static Future<String> uploadOfficialAccountHeaderToCloud(
      String path, String jid) async {
    LogMyUtil.v(
        "$TAG uploadOfficialAccountHeader ${path}|$UPLOAD_OFFICIAL_ACCOUNT_HEADER_URL");
    return await UploadCloudUtils.uploadCloud(
        path, jid, UPLOAD_OFFICIAL_ACCOUNT_HEADER_URL);
  }

  //上传声音
  static Future<String> uploadVoice(String path, String jid) async {
    LogMyUtil.v("$TAG uploadVoice ${path}|$UPLOAD_VOICE_URL");
    return await upload(path, jid, UPLOAD_VOICE_URL);
  }

  //上传声音
  static Future<String> uploadVoiceToCloud(String path, String jid) async {
    LogMyUtil.v("$TAG uploadVoice ${path}|$UPLOAD_VOICE_URL");
    return await UploadCloudUtils.uploadCloud(path, jid, UPLOAD_VOICE_URL);
  }

  //申请公众号号
  static Future<String> applyOfficialAccount(OfficialAccountModel model) async {
    LogMyUtil.v(
        "$TAG applyOfficialAccount():data:${model.name}|APPLY_OFFICIAL_ACCOUNT_URL:$APPLY_OFFICIAL_ACCOUNT_URL");
    String result = '';
    try {
      var dio = getDio();
      final response =
          await dio.post(APPLY_OFFICIAL_ACCOUNT_URL, data: model.toJson());
      String res = response.data.toString();
      //  LogUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
        final Map objectJson = parsed["objects"];
        OfficialAccountModel model = OfficialAccountModel.fromJson(objectJson);
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to applyOfficialAccount|$e");
    }
    return result;
  }

  //编辑公众号号
  static Future<String> editOfficialAccount(OfficialAccountModel model) async {
    LogMyUtil.v("$TAG editOfficialAccount:data:${model.name}");
    String result = '';
    try {
      var dio = getDio();
      final response =
          await dio.post(EDIT_OFFICIAL_ACCOUNT_URL, data: model.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to editOfficialAccount|$e");
    }
    return result;
  }

  //关注公众号号
  static Future<String> followOfficialAccount(
      String username, String officialAccountId) async {
    String url =
        "${FOLLOW_OFFICIAL_ACCOUNT_URL}officialAccountId=${officialAccountId}&username=${username}";
    LogMyUtil.v(
        "$TAG followOfficialAccount():officialAccountId:$officialAccountId|$url");
    String result = '';
    try {
      var dio = getDio();
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = code;
      } else {
        String msg = parsed["msg"];
        result = msg;
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to followOfficialAccount()|$e");
    }
    return result;
  }

  //取消关注公众号号
  static Future<String> unfollowOfficialAccount(
      String username, String officialAccountId) async {
    String url =
        "${UNFOLLOW_OFFICIAL_ACCOUNT_URL}officialAccountId=${officialAccountId}&username=${username}";
    LogMyUtil.v(
        "$TAG unfollowOfficialAccount():officialAccountId:$officialAccountId|url:$url");
    String result = '';
    try {
      var dio = getDio();
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        String msg = parsed["msg"];
        result = msg;
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to unfollowOfficialAccount()|$e");
    }
    return result;
  }

  //获取关注公众号
  static Future<List<OfficialAccountModel>> getFollowOfficialAccounts(
      String username,
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${GET_FOLLOW_OFFICIAL_ACCOUNT_URL}username=${username}&page=${page}&limit=${limit}";
    // LogUtil.v("$TAG getFollowOfficialAccounts() url:$url");
    List<OfficialAccountModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      // LogUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      // LogUtil.v("$TAG res2Json:" + res2Json);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        // LogUtil.v("$TAG list:$list");
        OfficialAccountModelList modelList =
            OfficialAccountModelList.fromJson(list);
        resultList = modelList.officialAccountModelList;
        // LogUtil.v("$TAG getFollowOfficialAccounts() resultList:${resultList.length}");
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getFollowOfficialAccounts() |$e");
    }
    return resultList;
  }

  //获取公众号粉丝
  static Future<List<UserModel>> getOfficialAccountFollowers(
      String officialAccountId,
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${GET_OFFICIAL_ACCOUNT_FOLLOWERS_URL}officialAccountId=${officialAccountId}&page=${page}&limit=${limit}";
    LogMyUtil.v("$TAG getOfficialAccountFollowers() url:$url");
    List<UserModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        UserModelList modelList = UserModelList.fromJson(list);
        resultList = modelList.userModelList;
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getOfficialAccountFollowers() |$e");
    }
    return resultList;
  }

  //获取关注公众号文章
  static Future<List<TopicModel>> getFollowOfficialAccountTopics(
      String username,
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${GET_FOLLOW_OFFICIAL_ACCOUNT_TOPICS_URL}username=${username}&page=${page}&limit=${limit}";
    LogMyUtil.v("$TAG getFollowOfficialAccountTopics() url:$url");
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
//          if (2 == topic.type) {
//            LogMyUtil.v("$TAG group:${topic.detail}");
//          }
        });
      } else {
        String msg = parsed["msg"];
        LogMyUtil.e("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.e("$TAG fail to getFollowOfficialAccountTopics() |$e");
    }
    return resultList;
  }

  //查找公众号文章
  static Future<List<TopicModel>> searchOfficialAccountTopics(
      int officialAccountId,
      [int page = 0,
        int limit = 10]) async {
    String url =
        "${SEARCH_OFFICIAL_ACCOUNT_TOPICS_URL}officialAccountId=${officialAccountId}&page=${page}&limit=${limit}";
    LogMyUtil.v("$TAG searchOfficialAccountTopics() url:$url");
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
//        resultList.forEach((topic) {
//            LogMyUtil.v("$TAG group:${topic.detail}");
//        });
      } else {
        String msg = parsed["msg"];
        LogMyUtil.e("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.e("$TAG fail to getFollowOfficialAccountTopics() |$e");
    }
    return resultList;
  }


  //根据Id获取公众号文章
  static Future<TopicModel> getOfficialAccountTopic(String topicId) async {
    String url = "${GET_OFFICIAL_ACCOUNT_TOPIC_URL}topicId=${topicId}";
    LogMyUtil.v("$TAG getOfficialAccountTopic() url:$url");
    TopicModel topicModel;
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        final Map parsed1 = parsed["objects"];
        topicModel = TopicModel.fromJson(parsed1);
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getOfficialAccountTopic() |$e");
    }
    return topicModel;
  }

  //获取用户关联（创建）公众号
  static Future<List<OfficialAccountModel>> getUserOfficialAccountListByUserId(
      String username,
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${GET_USER_OFFICIAL_ACCOUNTS_URL}username=${username}&page=${page}&limit=${limit}";
    LogMyUtil.v("$TAG getUserOfficialAccountListByUserId() url:$url");
    List<OfficialAccountModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        OfficialAccountModelList modelList =
            OfficialAccountModelList.fromJson(list);
        resultList = modelList.officialAccountModelList;
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getUserOfficialAccountListByUserId() |$e");
    }
    return resultList;
  }

  //发布公告
  static Future<String> publishGroupBulletin(
      String groupId, String content) async {
    LogMyUtil.v("$TAG publishGroupBulletin:groupId:${groupId}");
    BulletinModel bulletin =
        new BulletinModel(groupJid: groupId, content: content);
    String result = '';
    try {
      var dio = getDio();
      final response =
          await dio.post(ADD_GROUP_BULLETIN_URL, data: bulletin.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to publishGroupBulletin|$e");
    }
    return result;
  }

  //发布公告
  static Future<String> addOfficialTopic(TopicModel topic) async {
    LogMyUtil.v("$TAG publishOfficialTopic:topic:${topic.officialAccountId}");

    String result = '';
    try {
      var dio = getDio(token);
      final response =
          await dio.post(ADD_OFFICIAL_ACCOUNT_TOPIC_URL, data: topic.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to publishOfficialTopic|$e");
    }
    return result;
  }

  //获取用群公告
  static Future<BulletinModel> getGroupBulletin(String groupId) async {
    String url = "${GET_GROUP_BULLETIN_URL}groupId=${groupId}";
    LogMyUtil.v("$TAG getGroupBulletin() url:$url");
    BulletinModel bulletinModel;
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"].toString();
      final Map objectJson = parsed["objects"];
      if (code == '0') {
        bulletinModel = BulletinModel.fromJson(objectJson);
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getGroupBulletin() |$e");
    }
    return bulletinModel;
  }

  static Future<List<OfficialAccountModel>> searchOfficialAccount(
      String keyword,
      [int page = 0,
      int limit = 10]) async {
    String url =
        "${SEARCH_OFFICIAL_ACCOUNT_URL}keyword=$keyword&page=${page}&limit=${limit}";
    LogMyUtil.e("searchOfficialAccount() url:$url");
    List<OfficialAccountModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        OfficialAccountModelList modelList =
            OfficialAccountModelList.fromJson(list);
        resultList = modelList.officialAccountModelList;
        LogMyUtil.e(
            "searchOfficialAccount() resultList:${resultList[0].followerCount}");
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to searchOfficialAccount() |$e");
    }
    return resultList;
  }

//搜索用户
  static Future<List<UserModel>> searchUser(String keyword,
      [int page = 0, int limit = 10]) async {
    String url =
        "${SEARCH_USER_NAME_URL}keyword=$keyword&page=${page}&limit=${limit}";
    LogMyUtil.e("searchUser() url:$url");
    List<UserModel> resultList = [];
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        List<dynamic> list = parsed["objects"];
        UserModelList modelList = UserModelList.fromJson(list);
        modelList.userModelList.forEach((user) {
          user.jid = user.username + "@" + DOMAIN;
        });
        resultList = modelList.userModelList;
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to searchOfficialAccount() |$e");
    }
    return resultList;
  }

  //搜索用户,返回账号
  static Future<String> getUsernameByPhone(String phone) async {
    String url = "${GET_USERNAME_BY_PHONE_URL}phone=$phone";
    LogMyUtil.e("getUsernameByPhone() url:$url");
    String account = "";
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        account = parsed["objects"];
        LogMyUtil.e("getUsernameByPhone() account:|$account");
      } else {
        String msg = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getUsernameByPhone()|$e");
    }
    return account;
  }

  //发送短信
  static Future<Msg> sendSms(String phone) async {
    String url = "${SEND_PHONE_SMS_URL}phone=$phone";
    LogMyUtil.e("sendSms() url:$url");
    Msg msg = new Msg();
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      msg.code = code;
      if ("0" == code) {
        msg.object = parsed["objects"];
        LogMyUtil.v("sendSms() SMS:|${msg.object}");
      } else {
        msg.desc = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to sendSms()|$e");
    }
    return msg;
  }

  //验证短信
  static Future<String> verifySms(String phone, String sms) async {
    String url = "${VERIFY_PHONE_SMS_URL}phone=$phone&verifyCode=$sms";
    LogMyUtil.e("verifySms() url:$url");
    String result = "0";
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" != code) {
        String msg = parsed["msg"];
        result = msg;
        LogMyUtil.v("$TAG msg:$msg");
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to sendSms()|$e");
      result = "1";
    }
    return result;
  }

  //用户重置密码
  static Future<String> resetUserPassword(UserModel user) async {
    LogMyUtil.v("$TAG resetUserPassword()");
    String result = '';
    try {
      var dio = getDio(token);
      final response =
          await dio.post(RESET_USER_PASSWORD_URL, data: user.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to resetUserPassword():|$e");
    }
    return result;
  }

  //根据手机生成openfire账号,用于注册
  static Future<Msg> generateAccountByPhone(String phone) async {
    String url = "${GENERATE_ACCOUNT_BY_PHONE_URL}phone=$phone";
    LogMyUtil.e("generateAccountByPhone() url:$url");
    Msg msg = new Msg();
    String account = "";
    try {
      var dio = getDio(token);
      final response = await dio.get(url);
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      msg.code = parsed["code"];
      if ("0" == msg.code) {
        msg.object = parsed["objects"];
        LogMyUtil.e("getAccountByPhone() account:|$account");
      } else {
        msg.desc = parsed["msg"];
        LogMyUtil.v("$TAG msg:$msg");
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to getAccountByPhone()|$e");
    }
    return msg;
  }

  //获取token
  static Future<UserModel> login(UserModel model) async {
    LogMyUtil.v(
        "$TAG login() ${model.username}/${model.password}|$LOGIN_FOR_TOKEN_URL");
    UserModel user = null;
    try {
      var dio = getDio(token);
      final response =
          await dio.post(LOGIN_FOR_TOKEN_URL, data: model.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        final Map objectJson = parsed["objects"];
        user = UserModel.fromJson(objectJson);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to login() |$e");
    }
    return user;
  }

  //通过account获取用户
  static Future<UserModel> getUserByJid(String jid) async {
    String account = jid;
    if (jid.contains("@")) {
      account = jid.split("@")[0];
    }
    String url = "${GET_USER_BY_JID_URL}account=$account";
    //  LogMyUtil.v("$TAG getUserByJid() url:$url|account:$account");
    UserModel user = null;
    try {
      var dio = getDio(token);
      await dio.get(url).then((response) {
        String res = response.data.toString();
        //LogMyUtil.v("$TAG res:" + res);
        String res2Json = json.encode(response.data);
        // LogMyUtil.v("$TAG res2Json:" + res2Json);
        final Map parsed = json.decode(res2Json);
        String code = parsed["code"];
        //  LogUtil.v("$TAG code:$code");;
        final Map objectJson = parsed["objects"];
        if (code == '0') {
          user = UserModel.fromJson(objectJson);
          //  LogMyUtil.v("$TAG getUserByJid() user:" + user.detail);
          // return user;
        }
        _authentic(code, res);
      });
    } catch (e) {
      LogMyUtil.v("$TAG fail to getUserByJid() |$e");
    }
    return user;
  }

  //编辑用户资料
  static Future<String> editUser(UserModel model) async {
    LogMyUtil.v("$TAG editUser:data:${model.detail}");
    String result = '';
    try {
      var dio = getDio(token);
      final response = await dio.post(EDIT_USER_URL, data: model.toJson());
      String res = response.data.toString();
      LogMyUtil.v("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      if ("0" == code) {
        result = '0';
      } else {
        result = parsed["msg"];
        LogMyUtil.v("$TAG msg:$result");
        _authentic(code, res);
      }
    } catch (e) {
      LogMyUtil.v("$TAG fail to editUser|$e");
    }
    return result;
  }

  //根据群id获取group
  static Future<GroupModel> getGroupByName(String name) async {
    if (name.contains("@")) {
      name = name.split("@")[0];
    }
    String url = "${GET_GROUP_BY_NAME_URL}name=$name";
    LogMyUtil.v("$TAG getGroupByName() url:$url");

    GroupModel model = null;
    try {
      var dio = getDio(token);
      await dio.get(url).then((response) {
        String res = response.data.toString();
        //LogMyUtil.v("$TAG res:" + res);
        String res2Json = json.encode(response.data);
        final Map parsed = json.decode(res2Json);
        String code = parsed["code"];
        //  LogUtil.v("$TAG code:$code");;
        final Map objectJson = parsed["objects"];
        if (code == '0') {
          model = GroupModel.fromJson(objectJson);
          LogMyUtil.v("$TAG getGroupByName() model:" + model.detail);
        }
        _authentic(code, res);
      });
    } catch (e) {
      LogMyUtil.v("$TAG fail to getGroupByName() |$e");
    }
    return model;
  }

  //根据群成员名称搜索群
  static Future<Msg> searchPublicGroup(String subject,
      [int page = 0, int limit = 10]) async {
    String url = "${SEARCH_GROUP_URL}subject=$subject&page=0&limit=10";
    LogMyUtil.v("$TAG searchPublicGroup():subject:$subject|url:$url");
    Msg msg = new Msg();
    try {
      var dio = getDio(token);
      await dio.get(url).then((response) {
        String res = response.data.toString();
        LogMyUtil.v("$TAG res:" + res);
        String res2Json = json.encode(response.data);
        final Map parsed = json.decode(res2Json);
        msg.code = parsed["code"];
        msg.desc = parsed["msg"];
        if (msg.code == '0') {
          List<dynamic> list = parsed["objects"];
          GroupModelList modelList = GroupModelList.fromJson(list);
          msg.object = modelList.groupModelList;
          //LogMyUtil.v("$TAG group:" + modelList.groupModelList[0].detail);
        }
      });
    } catch (e) {
      msg.code = Msg.FAILRUE;
      LogMyUtil.v("$TAG fail to searchUserGroup() |$e");
    }
    return msg;
  }

  //用户创建群信息
  static Future<String> searchUserGroup(String username, String subject) async {
    LogMyUtil.v("$TAG searchUserGroup():username:$username|subject:$subject");
    String result = '';
    try {
      var dio = getDio(token);
      String url =
          "http://192.168.10.191:5168/group/searchUserGroup?username=test1&name=test1&page=0&limit=10";
      LogMyUtil.v("$TAG getUserByJid() url:$url");
      await dio.get(url).then((response) {
        String res = response.data.toString();
        LogMyUtil.v("$TAG res:" + res);
        String res2Json = json.encode(response.data);
        // LogMyUtil.v("$TAG res2Json:" + res2Json);
        final Map parsed = json.decode(res2Json);
        String code = parsed["code"];
        //  LogUtil.v("$TAG code:$code");;
        final Map objectJson = parsed["objects"];
        if (code == '0') {}
      });
    } catch (e) {
      LogMyUtil.v("$TAG fail to searchUserGroup() |$e");
    }
    return result;
  }

  static Dio getDio([String token = null]) {
    var dio = new Dio();
    dio.options.baseUrl = BASE_SERVER_URL;
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout = 6000;
    dio.options.headers["token"] = token ?? (me?.token ?? token);
    return dio;
  }

  static void _authentic(String code, String res) {
    if ("1000" == code) {
      LogMyUtil.v("$TAG res:" + res);
      if (XMMPConnectionState.AUTHENTICATED == StoreState.status) {
        FlutterSmack.getMe();
      }
    }
  }
}
