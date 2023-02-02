/// 基础信息配置
class BaseConfig {
  // 定义
  // static const String token = 'd302214d-b02c-4abe-933d-c530b604c9d1';

  /// 服务器路径
   // static const baseUrl = "https://www.smawavelogin.com";
  // static const baseUrl = "http://192.168.225.10";
  static const baseUrl = "https://172.16.20.144";
  static const cloudBaseUrl = "http://172.16.20.231:8079";

  /// 版本更新路径
  static const updateUrl = "$baseUrl/";

  /// 公司首页协议
  static const companyWebProtocol = "https";

  /// 公司首页地址
  static const companyWebUrl = "www.baidu.com";

  ///高德定位Android key和iOS key
  static const gdIosKey = "c59c6723ee079e25746cda7e37e11101";

  // static const Map<String, dynamic> header = {
  //   "Cookie":
  //       '-goahead-session-=::webs.session::a9296e73e3daf429d402074990f1363d; token=$token'
  // };
}
