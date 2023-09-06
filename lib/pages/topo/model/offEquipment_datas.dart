class Autogenerated {
  int? conn;
  String? sn;
  String? name;
  String? connection;
  String? accessPoint;
  String? mode;
  String? leaseTime;
  String? ipaddress;
  String? macaddress;
  String? ssid;
  String? snr;
  String? dsrate;
  String? usrate;
  String? rxBytes;
  String? txBytes;

  Autogenerated(
      {this.conn,
      this.sn,
      this.name,
      this.connection,
      this.accessPoint,
      this.mode,
      this.leaseTime,
      this.ipaddress,
      this.macaddress,
      this.ssid,
      this.snr,
      this.dsrate,
      this.usrate,
      this.rxBytes,
      this.txBytes});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    conn = json['conn'];
    sn = json['sn'];
    name = json['name'];
    connection = json['connection'];
    accessPoint = json['accessPoint'];
    mode = json['mode'];
    leaseTime = json['leaseTime'];
    ipaddress = json['ipaddress'];
    macaddress = json['macaddress'];
    ssid = json['ssid'];
    snr = json['snr'];
    dsrate = json['dsrate'];
    usrate = json['usrate'];
    rxBytes = json['rxBytes'];
    txBytes = json['txBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conn'] = this.conn;
    data['sn'] = this.sn;
    data['name'] = this.name;
    data['connection'] = this.connection;
    data['accessPoint'] = this.accessPoint;
    data['mode'] = this.mode;
    data['leaseTime'] = this.leaseTime;
    data['ipaddress'] = this.ipaddress;
    data['macaddress'] = this.macaddress;
    data['ssid'] = this.ssid;
    data['snr'] = this.snr;
    data['dsrate'] = this.dsrate;
    data['usrate'] = this.usrate;
    data['rxBytes'] = this.rxBytes;
    data['txBytes'] = this.txBytes;
    return data;
  }
}