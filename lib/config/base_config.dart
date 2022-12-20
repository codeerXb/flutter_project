/// 基础信息配置
class BaseConfig {
  // 定义token
  static const String token = 'a88d7ec0-ffc8-4293-809b-7c6552606412';

  /// 服务器路径
  static const baseUrl = "https://172.16.20.119/data.html";

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
        '-goahead-session-=::webs.session::a0943e6b42f6b4f7c89b125580fca6b3; token=$token'
  };
}
