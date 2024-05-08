class RouterUpgradeBean {
  int? code;
  String? message;
  Data? data;

  RouterUpgradeBean({this.code, this.message, this.data});

  RouterUpgradeBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? upgradeFlag;
  String? type;
  String? version;
  String? md5;
  String? url;

  Data({this.upgradeFlag, this.type, this.version, this.md5, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    upgradeFlag = json['upgradeFlag'];
    type = json['type'];
    version = json['version'];
    md5 = json['md5'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['upgradeFlag'] = upgradeFlag;
    data['type'] = type;
    data['version'] = version;
    data['md5'] = md5;
    data['url'] = url;
    return data;
  }
}