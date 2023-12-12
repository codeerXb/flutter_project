/// 基础信息配置
class BaseConfig {
  /// 服务器路径
  static const baseUrl = "https://192.168.1.1";
  // Debug请求地址
  static const cloudBaseUrl = "http://172.16.11.201:8095";// http://172.16.110.51:8095(暂时废弃)
  // 上线公网地址 (201公网) http://222.71.171.172:18095
  // static const cloudBaseUrl = "http://3.234.163.231:8095";//(新aws公网地址) http://3.234.163.231:8095

  /// 版本更新路径
  static const updateUrl = "$baseUrl/";

  /// 公司首页协议
  static const companyWebProtocol = "http";

  /// 公司首页地址
  static const companyWebUrl = "3.234.163.231";

  ///高德定位Android key和iOS key
  static const gdIosKey = "c59c6723ee079e25746cda7e37e11101";

  // static const Map<String, dynamic> header = {
  //   "Cookie":
  //       '-goahead-session-=::webs.session::a9296e73e3daf429d402074990f1363d; token=$token'
  // };
}
