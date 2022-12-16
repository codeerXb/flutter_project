/// 基础信息配置
class BaseConfig {
  // 定义token
  static const String token = 'd6e85252-4fe9-488b-a648-b58b7209b576';

  /// 服务器路径
  static const baseUrl = "https://www.smawavelogin.com/data.html";

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
