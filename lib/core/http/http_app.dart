import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http_app_interceptor.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/base_config.dart';
import 'package:dio/adapter.dart';
import 'package:http_parser/http_parser.dart';

class App {
  App._internal();
  ///网络请求配置
  static final Dio appdio = Dio(BaseOptions(
    baseUrl: BaseConfig.cloudBaseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
    headers: BaseConfig.header,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json
  ));

  ///初始化dio
  static init() {
    (appdio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
      return null;
    };
    appdio.interceptors.add(CookieManager(CookieJar()));
    //添加拦截器
    appdio.interceptors.add(HttpAppInterceptors());
  }

  ///get请求
  static Future get(String url, [Map<String, dynamic>? params]) async {
    Response response;
    try {
      if (params != null) {
        response = await appdio.get(url, queryParameters: {
          ...params,
          // '_csrf_token': BaseConfig.token,
        });
      } else {
        response = await appdio.get(url);
      }
      return response.data;
    } on DioError catch (e) {
      debugPrint('++++++++++++');
      debugPrint(params.toString());
      debugPrint(e.toString());
      // handleError(e);
      debugPrint('+++++++++++++');
      rethrow;
    }
  }

  ///post请求
  static Future post(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? data,
      Map<String, dynamic>? header}) async {
    try {
      Response response = await appdio.post(url,
          queryParameters: params != null
              // ? {...params, '_csrf_token': BaseConfig.token}
              ? {...params}
              : null,
          options: Options(responseType: ResponseType.plain, headers: header),
          data: data);
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  ///put请求
  static Future put(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? data}) async {
    try {
      Response response = await appdio.put(url,
          queryParameters: params != null
              // ? {...params, '_csrf_token': BaseConfig.token}
              ? {...params}
              : null,
          options: Options(responseType: ResponseType.plain),
          data: data);
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  ///delete请求
  static Future delete(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? data}) async {
    try {
      Response response = await appdio.delete(url,
          queryParameters: params != null
              ? {...params}
              : null,
          options: Options(responseType: ResponseType.plain),
          data: data);
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  // 上传文件
  static Future uploadFile(String url, Map<String, dynamic> data) async {
    Response response = await appdio.post(url,
        data: FormData.fromMap(data),
        options: Options(headers: {'Content-Type': 'multipart/form-data'}));
    return response.data;
  }

  // 上传图片
  static Future uploadImg(XFile image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    final FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        path,
        filename: name,
        contentType: MediaType.parse("image/$suffix")
      )
    });
    // Send FormData
    Response response = await appdio.post('/platform/deviceFiles/upload', data: formData);
    return response.data;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  static void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }


  ///error统一处理
  static void handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        debugPrint("连接超时");
        ToastUtils.error(S.current.contimeout);
        break;
      case DioErrorType.sendTimeout:
        debugPrint("请求超时");
        ToastUtils.error(S.current.Reqtimeout);
        break;
      case DioErrorType.receiveTimeout:
        debugPrint("响应超时");
        ToastUtils.error(S.current.Restimeout);
        break;
      case DioErrorType.response:
        debugPrint("出现异常");
        ToastUtils.error(S.current.error);
        break;
      case DioErrorType.cancel:
        debugPrint(S.current.Reqcancellation);
        break;
      default:
        ToastUtils.error(S.current.networkError);
        debugPrint("未知错误");
        break;
    }
  }
}
