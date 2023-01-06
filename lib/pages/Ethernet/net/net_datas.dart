class netDatas {
  String? ethernetConnectMode;
  String? ethernetConnectOnly;
  String? ethernetConnectPriority;
  String? ethernetIp;
  String? ethernetMask;
  String? ethernetDefaultGateway;
  String? ethernetPrimaryDns;
  String? ethernetSecondaryDns;
  String? ethernetMtu;
  String? ethernetDetectServer;
  String? systemCurrentPlatform;
  String? wifiEzmeshEnable;

  netDatas(
      {this.ethernetConnectMode,
      this.ethernetConnectOnly,
      this.ethernetConnectPriority,
      this.ethernetIp,
      this.ethernetMask,
      this.ethernetDefaultGateway,
      this.ethernetPrimaryDns,
      this.ethernetSecondaryDns,
      this.ethernetMtu,
      this.ethernetDetectServer,
      this.systemCurrentPlatform,
      this.wifiEzmeshEnable});

  netDatas.fromJson(Map<String, dynamic> json) {
    ethernetConnectMode = json['ethernetConnectMode'];
    ethernetConnectOnly = json['ethernetConnectOnly'];
    ethernetConnectPriority = json['ethernetConnectPriority'];
    ethernetIp = json['ethernetIp'];
    ethernetMask = json['ethernetMask'];
    ethernetDefaultGateway = json['ethernetDefaultGateway'];
    ethernetPrimaryDns = json['ethernetPrimaryDns'];
    ethernetSecondaryDns = json['ethernetSecondaryDns'];
    ethernetMtu = json['ethernetMtu'];
    ethernetDetectServer = json['ethernetDetectServer'];
    systemCurrentPlatform = json['systemCurrentPlatform'];
    wifiEzmeshEnable = json['wifiEzmeshEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ethernetConnectMode'] = ethernetConnectMode;
    data['ethernetConnectOnly'] = ethernetConnectOnly;
    data['ethernetConnectPriority'] = ethernetConnectPriority;
    data['ethernetIp'] = ethernetIp;
    data['ethernetMask'] = ethernetMask;
    data['ethernetDefaultGateway'] = ethernetDefaultGateway;
    data['ethernetPrimaryDns'] = ethernetPrimaryDns;
    data['ethernetSecondaryDns'] = ethernetSecondaryDns;
    data['ethernetMtu'] = ethernetMtu;
    data['ethernetDetectServer'] = ethernetDetectServer;
    data['systemCurrentPlatform'] = systemCurrentPlatform;
    data['wifiEzmeshEnable'] = wifiEzmeshEnable;
    return data;
  }
}