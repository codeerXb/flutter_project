/// 基础信息配置
class BaseConfig {
  /// 服务器路径
  static var baseUrl = "";
  // Debug请求地址
  // static const cloudBaseUrl = "http://172.16.11.111:8003";
  //(新aws公网地址)
  static const cloudBaseUrl = "http://222.71.171.172:18000/web";

  /// websocket服务器地址:
  // static const mqttMainUrl = "ws://172.16.11.111:8083/mqtt"; // 测试地址
  // static const websocketPort = 8083;
  static const websocketPort = 18083;
  // 生产地址
  static const mqttMainUrl = "ws://222.71.171.172:18083/mqtt";

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
