import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';
import '../../config/base_config.dart';
import 'http_interceptor.dart';
import 'package:dio/adapter.dart';

class XHttp {
  XHttp._internal();

  ///网络请求配置
  static final Dio dio = Dio(BaseOptions(
    baseUrl: BaseConfig.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,
    // headers: BaseConfig.header,
  ));

  ///初始化dio
  static init() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
      return null;
    };
    dio.interceptors.add(CookieManager(CookieJar()));
    //添加拦截器
    dio.interceptors.add(HttpInterceptors());
  }

  ///get请求
  static Future get(String url, [Map<String, dynamic>? params]) async {
    Response response;
    try {
      if (params != null) {
        response = await dio.get(url, queryParameters: {
          ...params,
          // '_csrf_token': BaseConfig.token,
        });
      } else {
        response = await dio.get(url);
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
      {Map<String, dynamic>? params, Map<String, dynamic>? data}) async {
    Response response = await dio.post(url,
        queryParameters: params != null
            // ? {...params, '_csrf_token': BaseConfig.token}
            ? {...params}
            : null,
        data: data);
    return response.data;
  }

  /// 上传文件
  static Future uploadFile(String url, Map<String, dynamic> data) async {
    Response response = await dio.post(url, data: FormData.fromMap(data));
    return response.data;
  }

  ///下载文件
  static Future downloadFile(urlPath, savePath) async {
    late Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        debugPrint("$count $total");
      });
    } on DioError catch (e) {
      handleError(e);
    }
    return response.data;
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
