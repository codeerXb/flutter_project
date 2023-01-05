class ExceptionLogin {
  bool? success;
  int? code;
  String? msg;
  int? webLoginFailedTimes;
  int? webLoginRetryTimeout;

  ExceptionLogin(
      {this.success,
      this.code,
      this.msg,
      this.webLoginFailedTimes,
      this.webLoginRetryTimeout});

  ExceptionLogin.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    webLoginFailedTimes = json['webLoginFailedTimes'];
    webLoginRetryTimeout = json['webLoginRetryTimeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['msg'] = msg;
    data['webLoginFailedTimes'] = webLoginFailedTimes;
    data['webLoginRetryTimeout'] = webLoginRetryTimeout;
    return data;
  }
}
