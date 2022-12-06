import 'dart:convert';

/// 工具类
class StringUtil {

  static AsciiCodec asciiCodec = const AsciiCodec();
  ///email验证
  static const emailRegex = '^([\\w\\d\\-\\+]+)(\\.+[\\w\\d\\-\\+%]+)*@([\\w\\-]+\\.){1,5}(([A-Za-z]){2,30}|xn--[A-Za-z0-9]{1,26})\$';

  /// 判断一个对象是否为null
  /// @param object Object
  /// @return true：为空 false：非空
  static bool isNull(object) => object == null;

  /// 判断一个对象是否非null
  /// @param object Object
  /// @return true：非空 false：空
  static bool isNotNull(object) => !isNull(object);

  /// 判断一个对象是否为空
  /// @param object
  /// @return true：为空 false：非空
  static bool isEmpty(object){
    if(object is String || object is List || object is Map || object is Set){
      return isNull(object) || object.length == 0;
    } else {
      return isNull(object);
    }
  }

  /// 判断一个对象是否为非空
  /// @param object
  /// @return true：为空 false：非空
  static bool isNotEmpty(object) => !isEmpty(object);

  ///
  /// 如果给定的字符串为null，则返回给定的字符串或默认字符串
  ///
  static String defaultString(String? str, {String defaultStr = ''}) {
    return str ?? defaultStr;
  }

  /// 检查给定的字符串[s]是小写的
  static bool isLowerCase(String s) {
    return s == s.toLowerCase();
  }

  /// 检查给定的字符串[s]是大写的
  static bool isUpperCase(String s) {
    return s == s.toUpperCase();
  }

  /// 检查给定的字符串是否包含ASCII字符
  static bool isAscii(String s) {
    try {
      asciiCodec.decode(s.codeUnits);
    } catch (e) {
      return false;
    }
    return true;
  }

  /// 反转给定的字符串[s]
  /// Example : hello => olleh
  static String reverse(String s) {
    return String.fromCharCodes(s.runes.toList().reversed);
  }

  /// 检查给定的字符串是否是电子邮件地址
  static bool isEmail(String s) {
    var regExp = RegExp(emailRegex);
    return regExp.hasMatch(s);
  }

  /// 判断是否网络
  static bool isNetWorkImg(String img) {
    return img.startsWith('http') || img.startsWith('https');
  }

}
