class WanStatusBean {
  Data? data;

  WanStatusBean({this.data});

  WanStatusBean.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? networkWanSettingsConnectMode;
  String? ethernetLinkStatus;
  String? lteMainStatusGet;
  String? systemOnlineTime;
  String? networkWanSettingsIp;
  String? networkWanSettingsMask;
  String? networkWanSettingsGateway;
  String? networkWanSettingsDns;
  String? networkWanSettingsMac;
  String? networkWanSettingsInterface;
  String? systemDataRateUlCurrent;
  String? systemDataRateDlCurrent;
  String? lteDefaultGateway;

  Data(
      {this.networkWanSettingsConnectMode,
      this.ethernetLinkStatus,
      this.lteMainStatusGet,
      this.systemOnlineTime,
      this.networkWanSettingsIp,
      this.networkWanSettingsMask,
      this.networkWanSettingsGateway,
      this.networkWanSettingsDns,
      this.networkWanSettingsMac,
      this.networkWanSettingsInterface,
      this.systemDataRateUlCurrent,
      this.systemDataRateDlCurrent,
      this.lteDefaultGateway});

  Data.fromJson(Map<String, dynamic> json) {
    networkWanSettingsConnectMode = json['networkWanSettingsConnectMode'];
    ethernetLinkStatus = json['ethernetLinkStatus'];
    lteMainStatusGet = json['lteMainStatusGet'];
    systemOnlineTime = json['systemOnlineTime'];
    networkWanSettingsIp = json['networkWanSettingsIp'];
    networkWanSettingsMask = json['networkWanSettingsMask'];
    networkWanSettingsGateway = json['networkWanSettingsGateway'];
    networkWanSettingsDns = json['networkWanSettingsDns'];
    networkWanSettingsMac = json['networkWanSettingsMac'];
    networkWanSettingsInterface = json['networkWanSettingsInterface'];
    systemDataRateUlCurrent = json['systemDataRateUlCurrent'];
    systemDataRateDlCurrent = json['systemDataRateDlCurrent'];
    lteDefaultGateway = json['lteDefaultGateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['networkWanSettingsConnectMode'] = networkWanSettingsConnectMode;
    data['ethernetLinkStatus'] = ethernetLinkStatus;
    data['lteMainStatusGet'] = lteMainStatusGet;
    data['systemOnlineTime'] = systemOnlineTime;
    data['networkWanSettingsIp'] = networkWanSettingsIp;
    data['networkWanSettingsMask'] = networkWanSettingsMask;
    data['networkWanSettingsGateway'] = networkWanSettingsGateway;
    data['networkWanSettingsDns'] = networkWanSettingsDns;
    data['networkWanSettingsMac'] = networkWanSettingsMac;
    data['networkWanSettingsInterface'] = networkWanSettingsInterface;
    data['systemDataRateUlCurrent'] = systemDataRateUlCurrent;
    data['systemDataRateDlCurrent'] = systemDataRateDlCurrent;
    data['lteDefaultGateway'] = lteDefaultGateway;
    return data;
  }
}