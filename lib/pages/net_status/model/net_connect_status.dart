class NetConnecStatus {
  String? systemRebootFlag;
  String? webGuiRestartFlag;
  String? lteMainStatusGet;
  String? systemLedModeThree;
  String? lteSignalStrengthGet;
  String? lteRoam;
  String? systemDataRateDlCurrent;
  String? systemDataRateUlCurrent;
  String? wifiHaveOrNot;
  String? wifi5gHaveOrNot;
  String? wifiEnable;
  String? wifi5gEnable;
  String? ethernetConnectionStatus;
  String? systemVoiceServiceType;
  String? volteStatus;
  String? voipInfoRegistrationStatus;
  String? voipInfoLineStatus;

  NetConnecStatus(
      {this.systemRebootFlag,
      this.webGuiRestartFlag,
      this.lteMainStatusGet,
      this.systemLedModeThree,
      this.lteSignalStrengthGet,
      this.lteRoam,
      this.systemDataRateDlCurrent,
      this.systemDataRateUlCurrent,
      this.wifiHaveOrNot,
      this.wifi5gHaveOrNot,
      this.wifiEnable,
      this.wifi5gEnable,
      this.ethernetConnectionStatus,
      this.systemVoiceServiceType,
      this.volteStatus,
      this.voipInfoRegistrationStatus,
      this.voipInfoLineStatus});

  NetConnecStatus.fromJson(Map<String, dynamic> json) {
    systemRebootFlag = json['systemRebootFlag'];
    webGuiRestartFlag = json['webGuiRestartFlag'];
    lteMainStatusGet = json['lteMainStatusGet'];
    systemLedModeThree = json['systemLedModeThree'];
    lteSignalStrengthGet = json['lteSignalStrengthGet'];
    lteRoam = json['lteRoam'];
    systemDataRateDlCurrent = json['systemDataRateDlCurrent'];
    systemDataRateUlCurrent = json['systemDataRateUlCurrent'];
    wifiHaveOrNot = json['wifiHaveOrNot'];
    wifi5gHaveOrNot = json['wifi5gHaveOrNot'];
    wifiEnable = json['wifiEnable'];
    wifi5gEnable = json['wifi5gEnable'];
    ethernetConnectionStatus = json['ethernetConnectionStatus'];
    systemVoiceServiceType = json['systemVoiceServiceType'];
    volteStatus = json['volteStatus'];
    voipInfoRegistrationStatus = json['voipInfoRegistrationStatus'];
    voipInfoLineStatus = json['voipInfoLineStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['systemRebootFlag'] = systemRebootFlag;
    data['webGuiRestartFlag'] = webGuiRestartFlag;
    data['lteMainStatusGet'] = lteMainStatusGet;
    data['systemLedModeThree'] = systemLedModeThree;
    data['lteSignalStrengthGet'] = lteSignalStrengthGet;
    data['lteRoam'] = lteRoam;
    data['systemDataRateDlCurrent'] = systemDataRateDlCurrent;
    data['systemDataRateUlCurrent'] = systemDataRateUlCurrent;
    data['wifiHaveOrNot'] = wifiHaveOrNot;
    data['wifi5gHaveOrNot'] = wifi5gHaveOrNot;
    data['wifiEnable'] = wifiEnable;
    data['wifi5gEnable'] = wifi5gEnable;
    data['ethernetConnectionStatus'] = ethernetConnectionStatus;
    data['systemVoiceServiceType'] = systemVoiceServiceType;
    data['volteStatus'] = volteStatus;
    data['voipInfoRegistrationStatus'] = voipInfoRegistrationStatus;
    data['voipInfoLineStatus'] = voipInfoLineStatus;
    return data;
  }
}
