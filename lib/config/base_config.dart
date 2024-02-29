/// 基础信息配置
class BaseConfig {
  /// 服务器路径
  static var baseUrl = "";
  // Debug请求地址
  // static const cloudBaseUrl = "http://10.0.30.43:8003";
  //(新aws公网地址)
  static const cloudBaseUrl = "http://3.234.163.231:8000/web";

  /// websocket服务器地址:
  // static const mqttMainUrl = "ws://10.0.30.43:8083/mqtt"; // 测试地址
  static const websocketPort = 8083;
  // AWS地址
  static const mqttMainUrl = "ws://3.234.163.231:8083/mqtt";

  /// 版本更新路径
  // static const updateUrl = "$baseUrl/";

  /// 公司首页协议
  static const companyWebProtocol = "https";

  /// 公司首页地址
  static const companyWebUrl = "://codiumnetworks.com/";

  ///高德定位Android key和iOS key
  static const gdIosKey = "c59c6723ee079e25746cda7e37e11101";

  static const Map<String, dynamic> header = {
    // 'Accept': 'application/json,*/*',
    // 'Content-Type': 'application/json',
  };
}
