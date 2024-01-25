/// 基础信息配置
class BaseConfig {
  /// 服务器路径
  static const baseUrl = "https://192.168.1.1";
  // Debug请求地址
  static const cloudBaseUrl = "http://10.0.30.194:8003";
  // 上线公网地址 (201公网) http://222.71.171.172:18095
  // static const cloudBaseUrl = "http://3.234.163.231:8095";//(新aws公网地址) http://3.234.163.231:8095

  /// websocket服务器地址:
  static const mqttMainUrl = "ws://10.0.30.194:8083/mqtt"; // 测试地址
  static const websocketPort = 8083;
  // static const mqttMainUrl = "ws://3.234.163.231:8083/mqtt";// AWS地址

  /// 版本更新路径
  static const updateUrl = "$baseUrl/";

  /// 公司首页协议
  static const companyWebProtocol = "http";

  /// 公司首页地址
  static const companyWebUrl = "3.234.163.231";

  ///高德定位Android key和iOS key
  static const gdIosKey = "c59c6723ee079e25746cda7e37e11101";

  static const Map<String, dynamic> header = {
    // 'Accept': 'application/json,*/*',
    // 'Content-Type': 'application/json',
  };
}
