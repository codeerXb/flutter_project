class EquipmentData {
  String? systemProductModel;
  String? systemVersionHw;
  String? systemVersionRunning;
  String? systemVersionUboot;
  String? systemVersionSn;
  String? lteImei;
  String? lteImsi;
  String? networkLanSettingsMac;
  String? networkLanSettingIp;
  String? networkLanSettingMask;
  String? systemRunningTime;

  EquipmentData(
      {this.systemProductModel,
      this.systemVersionHw,
      this.systemVersionRunning,
      this.systemVersionUboot,
      this.systemVersionSn,
      this.lteImei,
      this.lteImsi,
      this.networkLanSettingsMac,
      this.networkLanSettingIp,
      this.networkLanSettingMask,
      this.systemRunningTime});

  EquipmentData.fromJson(Map<String, dynamic> json) {
    systemProductModel = json['systemProductModel'];
    systemVersionHw = json['systemVersionHw'];
    systemVersionRunning = json['systemVersionRunning'];
    systemVersionUboot = json['systemVersionUboot'];
    systemVersionSn = json['systemVersionSn'];
    lteImei = json['lteImei'];
    lteImsi = json['lteImsi'];
    networkLanSettingsMac = json['networkLanSettingsMac'];
    networkLanSettingIp = json['networkLanSettingIp'];
    networkLanSettingMask = json['networkLanSettingMask'];
    systemRunningTime = json['systemRunningTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['systemProductModel'] = systemProductModel;
    data['systemVersionHw'] = systemVersionHw;
    data['systemVersionRunning'] = systemVersionRunning;
    data['systemVersionUboot'] = systemVersionUboot;
    data['systemVersionSn'] = systemVersionSn;
    data['lteImei'] = lteImei;
    data['lteImsi'] = lteImsi;
    data['networkLanSettingsMac'] = networkLanSettingsMac;
    data['networkLanSettingIp'] = networkLanSettingIp;
    data['networkLanSettingMask'] = networkLanSettingMask;
    data['systemRunningTime'] = systemRunningTime;
    return data;
  }
}
