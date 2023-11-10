class wlanBean {
  Data? data;

  wlanBean({this.data});

  wlanBean.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? wifiEnable;
  String? wifiMode;
  String? wifiHtmode;
  String? wifiChannel;
  String? wifiTxpower;

  Data(
      {this.wifiEnable,
      this.wifiMode,
      this.wifiHtmode,
      this.wifiChannel,
      this.wifiTxpower});

  Data.fromJson(Map<String, dynamic> json) {
    wifiEnable = json['wifiEnable'];
    wifiMode = json['wifiMode'];
    wifiHtmode = json['wifiHtmode'];
    wifiChannel = json['wifiChannel'];
    wifiTxpower = json['wifiTxpower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wifiEnable'] = this.wifiEnable;
    data['wifiMode'] = this.wifiMode;
    data['wifiHtmode'] = this.wifiHtmode;
    data['wifiChannel'] = this.wifiChannel;
    data['wifiTxpower'] = this.wifiTxpower;
    return data;
  }
}