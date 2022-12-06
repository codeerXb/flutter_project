import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_template/config/base_config.dart';

///cookie 工具类
class CookieUtils{

  static Future<Map<String, String>> getHeaders() async {
    var cookieJar = CookieJar();
    List<Cookie> results = await cookieJar.loadForRequest(Uri.parse(BaseConfig.baseUrl));
    String thisCookie = CookieManager.getCookies(results);
    Map<String, String> headers = {'Cookie': thisCookie};
    return headers;
  }

}