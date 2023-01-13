class vis2gDatas {
  List<WiFiSsidTable>? wiFiSsidTable;
  int? max;

  vis2gDatas({this.wiFiSsidTable, this.max});

  vis2gDatas.fromJson(Map<String, dynamic> json) {
    if (json['WiFiSsidTable'] != null) {
      wiFiSsidTable = <WiFiSsidTable>[];
      json['WiFiSsidTable'].forEach((v) {
        wiFiSsidTable!.add(WiFiSsidTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wiFiSsidTable != null) {
      data['WiFiSsidTable'] =
          wiFiSsidTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class WiFiSsidTable {
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
  String? wifiRadiusServerIP;
  String? wifiRadiusServerPort;
  String? wifiRadiusSharedKey;

  WiFiSsidTable(
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
      this.wifiRadiusServerIP,
      this.wifiRadiusServerPort,
      this.wifiRadiusSharedKey});

  WiFiSsidTable.fromJson(Map<String, dynamic> json) {
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
    wifiRadiusServerIP = json['wifiRadiusServerIP'];
    wifiRadiusServerPort = json['wifiRadiusServerPort'];
    wifiRadiusSharedKey = json['wifiRadiusSharedKey'];
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
    data['wifiRadiusServerIP'] = wifiRadiusServerIP;
    data['wifiRadiusServerPort'] = wifiRadiusServerPort;
    data['wifiRadiusSharedKey'] = wifiRadiusSharedKey;
    return data;
  }
}