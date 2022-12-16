/// 基础信息配置
class BaseConfig {
  // 定义token
  static const String token = '63545f20-2975-43eb-8049-262e04552377';

  /// 服务器路径
  static const baseUrl = "https://172.16.20.68/data.html";

  /// 版本更新路径
  static const updateUrl = "$baseUrl/";

  /// 公司首页协议
  static const companyWebProtocol = "https";

  /// 公司首页地址
  static const companyWebUrl = "www.baidu.com";

  ///高德定位Android key和iOS key
  static const gdIosKey = "c59c6723ee079e25746cda7e37e11101";

  static const Map<String, dynamic> header = {
    "Cookie":
        '-goahead-session-=::webs.session::dd962ca6bbad8907b142f4bde5c6d765; token=$token'
  };
}
