class OfflineListBean {
  int? code;
  String? message;
  List<Data>? data;

  OfflineListBean({this.code, this.message, this.data});

  OfflineListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? conn;
  String? sn;
  String? name;
  String? connection;
  String? accessPoint;
  String? mode;
  String? leaseTime;
  String? macaddress;
  String? ssid;
  String? snr;
  String? dsrate;
  String? usrate;
  String? ipaddress;
  String? rxBytes;
  String? txBytes;

  Data(
      {this.conn,
      this.sn,
      this.name,
      this.connection,
      this.accessPoint,
      this.mode,
      this.leaseTime,
      this.macaddress,
      this.ssid,
      this.snr,
      this.dsrate,
      this.usrate,
      this.ipaddress,
      this.rxBytes,
      this.txBytes});

  Data.fromJson(Map<String, dynamic> json) {
    conn = json['conn'];
    sn = json['sn'];
    name = json['name'];
    connection = json['connection'];
    accessPoint = json['accessPoint'];
    mode = json['mode'];
    leaseTime = json['leaseTime'];
    macaddress = json['macaddress'];
    ssid = json['ssid'];
    snr = json['snr'];
    dsrate = json['dsrate'];
    usrate = json['usrate'];
    ipaddress = json['ipaddress'];
    rxBytes = json['rxBytes'];
    txBytes = json['txBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conn'] = conn;
    data['sn'] = sn;
    data['name'] = name;
    data['connection'] = connection;
    data['accessPoint'] = accessPoint;
    data['mode'] = mode;
    data['leaseTime'] = leaseTime;
    data['macaddress'] = macaddress;
    data['ssid'] = ssid;
    data['snr'] = snr;
    data['dsrate'] = dsrate;
    data['usrate'] = usrate;
    data['ipaddress'] = ipaddress;
    data['rxBytes'] = rxBytes;
    data['txBytes'] = txBytes;
    return data;
  }
}