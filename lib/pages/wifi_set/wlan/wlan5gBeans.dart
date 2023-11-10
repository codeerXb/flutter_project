class wlanAdvancedBean {
  Data? data;

  wlanAdvancedBean({this.data});

  wlanAdvancedBean.fromJson(Map<String, dynamic> json) {
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
  String? wifi5gEnable;
  String? wifi5gMode;
  String? wifi5gHtmode;
  String? wifi5gChannel;
  String? wifi5gTxpower;

  Data(
      {this.wifi5gEnable,
      this.wifi5gMode,
      this.wifi5gHtmode,
      this.wifi5gChannel,
      this.wifi5gTxpower});

  Data.fromJson(Map<String, dynamic> json) {
    wifi5gEnable = json['wifi5gEnable'];
    wifi5gMode = json['wifi5gMode'];
    wifi5gHtmode = json['wifi5gHtmode'];
    wifi5gChannel = json['wifi5gChannel'];
    wifi5gTxpower = json['wifi5gTxpower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wifi5gEnable'] = this.wifi5gEnable;
    data['wifi5gMode'] = this.wifi5gMode;
    data['wifi5gHtmode'] = this.wifi5gHtmode;
    data['wifi5gChannel'] = this.wifi5gChannel;
    data['wifi5gTxpower'] = this.wifi5gTxpower;
    return data;
  }
}