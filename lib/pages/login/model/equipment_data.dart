// ignore: camel_case_types
class EquipmentData {
  String? systemProductModel;
  String? systemVersionRunning;
  String? wifi5gHaveOrNot;
  String? wifiEnable;
  String? wifiCurrentChannel;
  String? wifiMode;
  String? wifiSsid;
  String? wifi5gEnable;
  String? wifi5gCurrentChannel;
  String? wifi5gMode;
  String? lteNetwork;
  String? networkWanSettingsMode;
  String? wifiHaveOrNot;
  String? lteDefaultGateway;
  String? systemCurrentPlatform;
  String? systemGpsSupport;
  String? systemOnlineTime;
  String? systemRunningTime;
  String? lteMainStatusGet;
  String? lteOperatorGet;
  String? lteModeGet;
  String? lteCellidGet;
  String? lteRsrp0;
  String? lteRsrp1;
  String? lteRsrq;
  String? lteSinr;
  String? lteCellidGet5g;
  String? lteRsrp05g;
  String? lteRsrp15g;
  String? lteRsrq5g;
  String? lteSinr5g;
  String? networkWanSettingsIp;
  String? networkWanSettingsMask;
  String? networkIpv6WanSettingsIp;
  String? networkIpv6WanSettingsMask;
  String? systemGpsLongitude;
  String? systemGpsLatitude;
  String? systemGpsAltitude;
  String? networkWanSettingsDns;
  String? networkIpv6WanSettingsDns1;
  String? networkIpv6WanSettingsDns2;

  EquipmentData(
      {this.systemProductModel,
      this.systemVersionRunning,
      this.wifi5gHaveOrNot,
      this.wifiEnable,
      this.wifiCurrentChannel,
      this.wifiMode,
      this.wifiSsid,
      this.wifi5gEnable,
      this.wifi5gCurrentChannel,
      this.wifi5gMode,
      this.lteNetwork,
      this.networkWanSettingsMode,
      this.wifiHaveOrNot,
      this.lteDefaultGateway,
      this.systemCurrentPlatform,
      this.systemGpsSupport,
      this.systemOnlineTime,
      this.systemRunningTime,
      this.lteMainStatusGet,
      this.lteOperatorGet,
      this.lteModeGet,
      this.lteCellidGet,
      this.lteRsrp0,
      this.lteRsrp1,
      this.lteRsrq,
      this.lteSinr,
      this.lteCellidGet5g,
      this.lteRsrp05g,
      this.lteRsrp15g,
      this.lteRsrq5g,
      this.lteSinr5g,
      this.networkWanSettingsIp,
      this.networkWanSettingsMask,
      this.networkIpv6WanSettingsIp,
      this.networkIpv6WanSettingsMask,
      this.systemGpsLongitude,
      this.systemGpsLatitude,
      this.systemGpsAltitude,
      this.networkWanSettingsDns,
      this.networkIpv6WanSettingsDns1,
      this.networkIpv6WanSettingsDns2});

  EquipmentData.fromJson(Map<String, dynamic> json) {
    systemProductModel = json['systemProductModel'];
    systemVersionRunning = json['systemVersionRunning'];
    wifi5gHaveOrNot = json['wifi5gHaveOrNot'];
    wifiEnable = json['wifiEnable'];
    wifiCurrentChannel = json['wifiCurrentChannel'];
    wifiMode = json['wifiMode'];
    wifiSsid = json['wifiSsid'];
    wifi5gEnable = json['wifi5gEnable'];
    wifi5gCurrentChannel = json['wifi5gCurrentChannel'];
    wifi5gMode = json['wifi5gMode'];
    lteNetwork = json['lteNetwork'];
    networkWanSettingsMode = json['networkWanSettingsMode'];
    wifiHaveOrNot = json['wifiHaveOrNot'];
    lteDefaultGateway = json['lteDefaultGateway'];
    systemCurrentPlatform = json['systemCurrentPlatform'];
    systemGpsSupport = json['systemGpsSupport'];
    systemOnlineTime = json['systemOnlineTime'];
    systemRunningTime = json['systemRunningTime'];
    lteMainStatusGet = json['lteMainStatusGet'];
    lteOperatorGet = json['lteOperatorGet'];
    lteModeGet = json['lteModeGet'];
    lteCellidGet = json['lteCellidGet'];
    lteRsrp0 = json['lteRsrp0'];
    lteRsrp1 = json['lteRsrp1'];
    lteRsrq = json['lteRsrq'];
    lteSinr = json['lteSinr'];
    lteCellidGet5g = json['lteCellidGet_5g'];
    lteRsrp05g = json['lteRsrp0_5g'];
    lteRsrp15g = json['lteRsrp1_5g'];
    lteRsrq5g = json['lteRsrq_5g'];
    lteSinr5g = json['lteSinr_5g'];
    networkWanSettingsIp = json['networkWanSettingsIp'];
    networkWanSettingsMask = json['networkWanSettingsMask'];
    networkIpv6WanSettingsIp = json['networkIpv6WanSettingsIp'];
    networkIpv6WanSettingsMask = json['networkIpv6WanSettingsMask'];
    systemGpsLongitude = json['systemGpsLongitude'];
    systemGpsLatitude = json['systemGpsLatitude'];
    systemGpsAltitude = json['systemGpsAltitude'];
    networkWanSettingsDns = json['networkWanSettingsDns'];
    networkIpv6WanSettingsDns1 = json['networkIpv6WanSettingsDns1'];
    networkIpv6WanSettingsDns2 = json['networkIpv6WanSettingsDns2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['systemProductModel'] = systemProductModel;
    data['systemVersionRunning'] = systemVersionRunning;
    data['wifi5gHaveOrNot'] = wifi5gHaveOrNot;
    data['wifiEnable'] = wifiEnable;
    data['wifiCurrentChannel'] = wifiCurrentChannel;
    data['wifiMode'] = wifiMode;
    data['wifiSsid'] = wifiSsid;
    data['wifi5gEnable'] = wifi5gEnable;
    data['wifi5gCurrentChannel'] = wifi5gCurrentChannel;
    data['wifi5gMode'] = wifi5gMode;
    data['lteNetwork'] = lteNetwork;
    data['networkWanSettingsMode'] = networkWanSettingsMode;
    data['wifiHaveOrNot'] = wifiHaveOrNot;
    data['lteDefaultGateway'] = lteDefaultGateway;
    data['systemCurrentPlatform'] = systemCurrentPlatform;
    data['systemGpsSupport'] = systemGpsSupport;
    data['systemOnlineTime'] = systemOnlineTime;
    data['systemRunningTime'] = systemRunningTime;
    data['lteMainStatusGet'] = lteMainStatusGet;
    data['lteOperatorGet'] = lteOperatorGet;
    data['lteModeGet'] = lteModeGet;
    data['lteCellidGet'] = lteCellidGet;
    data['lteRsrp0'] = lteRsrp0;
    data['lteRsrp1'] = lteRsrp1;
    data['lteRsrq'] = lteRsrq;
    data['lteSinr'] = lteSinr;
    data['lteCellidGet_5g'] = lteCellidGet5g;
    data['lteRsrp0_5g'] = lteRsrp05g;
    data['lteRsrp1_5g'] = lteRsrp15g;
    data['lteRsrq_5g'] = lteRsrq5g;
    data['lteSinr_5g'] = lteSinr5g;
    data['networkWanSettingsIp'] = networkWanSettingsIp;
    data['networkWanSettingsMask'] = networkWanSettingsMask;
    data['networkIpv6WanSettingsIp'] = networkIpv6WanSettingsIp;
    data['networkIpv6WanSettingsMask'] = networkIpv6WanSettingsMask;
    data['systemGpsLongitude'] = systemGpsLongitude;
    data['systemGpsLatitude'] = systemGpsLatitude;
    data['systemGpsAltitude'] = systemGpsAltitude;
    data['networkWanSettingsDns'] = networkWanSettingsDns;
    data['networkIpv6WanSettingsDns1'] = networkIpv6WanSettingsDns1;
    data['networkIpv6WanSettingsDns2'] = networkIpv6WanSettingsDns2;
    return data;
  }
}
