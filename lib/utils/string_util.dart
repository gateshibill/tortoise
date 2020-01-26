import 'package:flustars/flustars.dart';

String subString(String str, int length) {
  if (null == str) {
    return "";
  } else {
    return '${str.substring(0, (str.length > length ? length : str.length))}';
  }
}

class StringUtils {
  //获取性别
  static getSex(String str) {
    String _sex = '未设置';
    if (ObjectUtil.isEmptyString(str)) {
      _sex = '未设置';
    } else if (str == '1') {
      _sex = '男';
    } else if (str == '0') {
      _sex = '女';
    }
    return _sex;
  }

  //获取性别
  static getSexInt(String str) {
    int _sex = 2; //未知
    if (ObjectUtil.isEmptyString(str)) {
      _sex = 2;
    } else if ('男' == str) {
      _sex = 1;
    } else if ('女' == str) {
      _sex = 0;
    }
    return _sex;
  }
}
