class TerminalEquipmentBean {
  int? code;
  String? message;
  Data? data;

  TerminalEquipmentBean({this.code, this.message, this.data});

  TerminalEquipmentBean.fromJson(Map<String, dynamic> json) {
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
  List<WifiDevices>? lanDevices;
  List<WifiDevices>? wifiDevices;

  Data({this.lanDevices, this.wifiDevices});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lanDevices'] != null) {
      lanDevices = <WifiDevices>[];
      json['lanDevices'].forEach((v) {
        lanDevices!.add(WifiDevices.fromJson(v));
      });
    }
    if (json['wifiDevices'] != null) {
      wifiDevices = <WifiDevices>[];
      json['wifiDevices'].forEach((v) {
        wifiDevices!.add(WifiDevices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lanDevices != null) {
      data['lanDevices'] = lanDevices!.map((v) => v.toJson()).toList();
    }
    if (wifiDevices != null) {
      data['wifiDevices'] = wifiDevices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WifiDevices {
  String? dSRate;
  String? iPAddress;
  String? mACAddress;
  String? sNR;
  String? sSID;
  String? uSRate;
  String? accessPoint;
  int? conn;
  String? connection;
  String? mode;
  String? name;
  String? rxBytes;
  String? txBytes;

  WifiDevices(
      {this.dSRate,
      this.iPAddress,
      this.mACAddress,
      this.sNR,
      this.sSID,
      this.uSRate,
      this.accessPoint,
      this.conn,
      this.connection,
      this.mode,
      this.name,
      this.rxBytes,
      this.txBytes});

  WifiDevices.fromJson(Map<String, dynamic> json) {
    dSRate = json['DSRate'];
    iPAddress = json['IPAddress'];
    mACAddress = json['MACAddress'];
    sNR = json['SNR'];
    sSID = json['SSID'];
    uSRate = json['USRate'];
    accessPoint = json['accessPoint'];
    conn = json['conn'];
    connection = json['connection'];
    mode = json['mode'];
    name = json['name'];
    rxBytes = json['rxBytes'];
    txBytes = json['txBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DSRate'] = dSRate;
    data['IPAddress'] = iPAddress;
    data['MACAddress'] = mACAddress;
    data['SNR'] = sNR;
    data['SSID'] = sSID;
    data['USRate'] = uSRate;
    data['accessPoint'] = accessPoint;
    data['conn'] = conn;
    data['connection'] = connection;
    data['mode'] = mode;
    data['name'] = name;
    data['rxBytes'] = rxBytes;
    data['txBytes'] = txBytes;
    return data;
  }
}