class majorDatas {
  String? wifiRegionCountry;
  String? wifiWpsPbcState;
  String? wifi5gWpsPbcState;

  majorDatas(
      {this.wifiRegionCountry, this.wifiWpsPbcState, this.wifi5gWpsPbcState});

  majorDatas.fromJson(Map<String, dynamic> json) {
    wifiRegionCountry = json['wifiRegionCountry'];
    wifiWpsPbcState = json['wifiWpsPbcState'];
    wifi5gWpsPbcState = json['wifi5gWpsPbcState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiRegionCountry'] = wifiRegionCountry;
    data['wifiWpsPbcState'] = wifiWpsPbcState;
    data['wifi5gWpsPbcState'] = wifi5gWpsPbcState;
    return data;
  }
}