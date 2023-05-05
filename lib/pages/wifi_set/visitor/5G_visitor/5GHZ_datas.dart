class Vis5gDatas {
  List<dynamic>? wiFi5GSsidTable;
  int? max;

  Vis5gDatas({this.wiFi5GSsidTable, this.max});

  Vis5gDatas.fromJson(Map<String, dynamic> json) {
    if (json['WiFi5GSsidTable'] != null) {
      wiFi5GSsidTable = <WiFi5GSsidTable>[];
      json['WiFi5GSsidTable'].forEach((v) {
        wiFi5GSsidTable!.add(WiFi5GSsidTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wiFi5GSsidTable != null) {
      data['WiFi5GSsidTable'] =
          wiFi5GSsidTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class WiFi5GSsidTable {
  int? id;
  String? enable;
  String? ssidHide;
  String? apIsolate;
  String? showPasswd;
  String? is4Guest;
  String? passwordLength;
  String? passwordIndex;
  String? maxClient;
  String? ssid;
  String? key;
  String? password1;
  String? password2;
  String? password3;
  String? password4;
  String? encryption;
  String? ssidMac;
  String? allowAccessIntranet;
  String? wifi5gRadiusServerIP;
  String? wifi5gRadiusServerPort;
  String? wifi5gRadiusSharedKey;

  WiFi5GSsidTable(
      {this.id,
      this.enable,
      this.ssidHide,
      this.apIsolate,
      this.showPasswd,
      this.is4Guest,
      this.passwordLength,
      this.passwordIndex,
      this.maxClient,
      this.ssid,
      this.key,
      this.password1,
      this.password2,
      this.password3,
      this.password4,
      this.encryption,
      this.ssidMac,
      this.allowAccessIntranet,
      this.wifi5gRadiusServerIP,
      this.wifi5gRadiusServerPort,
      this.wifi5gRadiusSharedKey});

  WiFi5GSsidTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enable = json['Enable'];
    ssidHide = json['SsidHide'];
    apIsolate = json['ApIsolate'];
    showPasswd = json['ShowPasswd'];
    is4Guest = json['Is4Guest'];
    passwordLength = json['PasswordLength'];
    passwordIndex = json['PasswordIndex'];
    maxClient = json['MaxClient'];
    ssid = json['Ssid'];
    key = json['Key'];
    password1 = json['Password1'];
    password2 = json['Password2'];
    password3 = json['Password3'];
    password4 = json['Password4'];
    encryption = json['Encryption'];
    ssidMac = json['SsidMac'];
    allowAccessIntranet = json['AllowAccessIntranet'];
    wifi5gRadiusServerIP = json['wifi5gRadiusServerIP'];
    wifi5gRadiusServerPort = json['wifi5gRadiusServerPort'];
    wifi5gRadiusSharedKey = json['wifi5gRadiusSharedKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Enable'] = enable;
    data['SsidHide'] = ssidHide;
    data['ApIsolate'] = apIsolate;
    data['ShowPasswd'] = showPasswd;
    data['Is4Guest'] = is4Guest;
    data['PasswordLength'] = passwordLength;
    data['PasswordIndex'] = passwordIndex;
    data['MaxClient'] = maxClient;
    data['Ssid'] = ssid;
    data['Key'] = key;
    data['Password1'] = password1;
    data['Password2'] = password2;
    data['Password3'] = password3;
    data['Password4'] = password4;
    data['Encryption'] = encryption;
    data['SsidMac'] = ssidMac;
    data['AllowAccessIntranet'] = allowAccessIntranet;
    data['wifi5gRadiusServerIP'] = wifi5gRadiusServerIP;
    data['wifi5gRadiusServerPort'] = wifi5gRadiusServerPort;
    data['wifi5gRadiusSharedKey'] = wifi5gRadiusSharedKey;
    return data;
  }
}
