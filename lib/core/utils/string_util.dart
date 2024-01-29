import 'dart:convert';
import 'dart:math';

/// 工具类
class StringUtil {
  static AsciiCodec asciiCodec = const AsciiCodec();

  ///email验证
  static const emailRegex =
      '^([\\w\\d\\-\\+]+)(\\.+[\\w\\d\\-\\+%]+)*@([\\w\\-]+\\.){1,5}(([A-Za-z]){2,30}|xn--[A-Za-z0-9]{1,26})\$';

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
  static bool isEmpty(object) {
    if (object is String || object is List || object is Map || object is Set) {
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

  /// 检查字符串是否为电话号码
  static bool isPhoneNumber(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]*$');
  }

  /// 检查给定的字符串是否是电子邮件地址
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  // static bool isEmail(String s) {
  //   var regExp = RegExp(emailRegex);
  //   return regExp.hasMatch(s);
  // }

  static bool isIp(String s) {
    return hasMatch(
        s, r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$");
  }

  /// 判断是否网络
  static bool isNetWorkImg(String img) {
    return img.startsWith('http') || img.startsWith('https');
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  /// 生成请求MQTT sessionId的随机字符串
  static String generateRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  static String getRate(rate) {
    double rateKb = rate * 8 / 1000;
    String unit = 'Kbps';
    if (rateKb >= 1000 * 1000) {
      // gbps
      rateKb = rateKb / 1000 / 1000;
      unit = 'Gbps';
    } else if (rateKb >= 1000 && rateKb <= 1000 * 1000) {
      // mbps
      rateKb = rateKb / 1000;
      unit = 'Mbps';
    } else {
      // kbps
      rateKb = rateKb;
      unit = 'Kbps';
    }
    return rateKb.toStringAsFixed(2) + unit;
  }
}
