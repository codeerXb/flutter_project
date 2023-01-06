class LanSettingData {
  String? networkLanSettingIp;
  String? networkLanSettingMask;
  String? networkLanSettingDhcp;
  String? networkLanSettingStart;
  String? networkLanSettingEnd;
  String? networkLanSettingLeasetime;

  LanSettingData(
      {this.networkLanSettingIp,
      this.networkLanSettingMask,
      this.networkLanSettingDhcp,
      this.networkLanSettingStart,
      this.networkLanSettingEnd,
      this.networkLanSettingLeasetime});

  LanSettingData.fromJson(Map<String, dynamic> json) {
    networkLanSettingIp = json['networkLanSettingIp'];
    networkLanSettingMask = json['networkLanSettingMask'];
    networkLanSettingDhcp = json['networkLanSettingDhcp'];
    networkLanSettingStart = json['networkLanSettingStart'];
    networkLanSettingEnd = json['networkLanSettingEnd'];
    networkLanSettingLeasetime = json['networkLanSettingLeasetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['networkLanSettingIp'] = networkLanSettingIp;
    data['networkLanSettingMask'] = networkLanSettingMask;
    data['networkLanSettingDhcp'] = networkLanSettingDhcp;
    data['networkLanSettingStart'] = networkLanSettingStart;
    data['networkLanSettingEnd'] = networkLanSettingEnd;
    data['networkLanSettingLeasetime'] = networkLanSettingLeasetime;
    return data;
  }
}
