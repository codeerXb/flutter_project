class wpsDatas {
  String? wifiWps;
  String? wifiWpsMode;
  String? wifiWpsClientPin;
  String? wifi5gWps;
  String? wifi5gWpsMode;
  String? wifi5gWpsClientPin;

  wpsDatas(
      {this.wifiWps,
      this.wifiWpsMode,
      this.wifiWpsClientPin,
      this.wifi5gWps,
      this.wifi5gWpsMode,
      this.wifi5gWpsClientPin});

  wpsDatas.fromJson(Map<String, dynamic> json) {
    wifiWps = json['wifiWps'];
    wifiWpsMode = json['wifiWpsMode'];
    wifiWpsClientPin = json['wifiWpsClientPin'];
    wifi5gWps = json['wifi5gWps'];
    wifi5gWpsMode = json['wifi5gWpsMode'];
    wifi5gWpsClientPin = json['wifi5gWpsClientPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiWps'] = wifiWps;
    data['wifiWpsMode'] = wifiWpsMode;
    data['wifiWpsClientPin'] = wifiWpsClientPin;
    data['wifi5gWps'] = wifi5gWps;
    data['wifi5gWpsMode'] = wifi5gWpsMode;
    data['wifi5gWpsClientPin'] = wifi5gWpsClientPin;
    return data;
  }
}