class wlanDatas {
  String? wifiEnable;
  String? wifiMode;
  String? wifiHtmode;
  String? wifiChannel;
  String? wifiTxpower;
  String? wifi5gEnable;
  String? wifi5gMode;
  String? wifi5gHtmode;
  String? wifi5gChannel;
  String? wifi5gTxpower;

  wlanDatas(
      {this.wifiEnable,
      this.wifiMode,
      this.wifiHtmode,
      this.wifiChannel,
      this.wifiTxpower,
      this.wifi5gEnable,
      this.wifi5gMode,
      this.wifi5gHtmode,
      this.wifi5gChannel,
      this.wifi5gTxpower});

  wlanDatas.fromJson(Map<String, dynamic> json) {
    wifiEnable = json['wifiEnable'];
    wifiMode = json['wifiMode'];
    wifiHtmode = json['wifiHtmode'];
    wifiChannel = json['wifiChannel'];
    wifiTxpower = json['wifiTxpower'];
    wifi5gEnable = json['wifi5gEnable'];
    wifi5gMode = json['wifi5gMode'];
    wifi5gHtmode = json['wifi5gHtmode'];
    wifi5gChannel = json['wifi5gChannel'];
    wifi5gTxpower = json['wifi5gTxpower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiEnable'] = wifiEnable;
    data['wifiMode'] = wifiMode;
    data['wifiHtmode'] = wifiHtmode;
    data['wifiChannel'] = wifiChannel;
    data['wifiTxpower'] = wifiTxpower;
    data['wifi5gEnable'] = wifi5gEnable;
    data['wifi5gMode'] = wifi5gMode;
    data['wifi5gHtmode'] = wifi5gHtmode;
    data['wifi5gChannel'] = wifi5gChannel;
    data['wifi5gTxpower'] = wifi5gTxpower;
    return data;
  }
}