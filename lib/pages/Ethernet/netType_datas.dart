class NetTypeDatas {
  String? ethernetConnectMode;
  String? ethernetLinkStatus;
  String? ethernetConnectionStatus;
  String? systemOnlineTime;
  String? ethernetConnectionIp;
  String? ethernetConnectionMask;
  String? ethernetConnectionGateway;
  String? ethernetConnectionDns1;
  String? ethernetConnectionDns2;

  NetTypeDatas(
      {this.ethernetConnectMode,
      this.ethernetLinkStatus,
      this.ethernetConnectionStatus,
      this.systemOnlineTime,
      this.ethernetConnectionIp,
      this.ethernetConnectionMask,
      this.ethernetConnectionGateway,
      this.ethernetConnectionDns1,
      this.ethernetConnectionDns2});

  NetTypeDatas.fromJson(Map<String, dynamic> json) {
    ethernetConnectMode = json['ethernetConnectMode'];
    ethernetLinkStatus = json['ethernetLinkStatus'];
    ethernetConnectionStatus = json['ethernetConnectionStatus'];
    systemOnlineTime = json['systemOnlineTime'];
    ethernetConnectionIp = json['ethernetConnectionIp'];
    ethernetConnectionMask = json['ethernetConnectionMask'];
    ethernetConnectionGateway = json['ethernetConnectionGateway'];
    ethernetConnectionDns1 = json['ethernetConnectionDns1'];
    ethernetConnectionDns2 = json['ethernetConnectionDns2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ethernetConnectMode'] = ethernetConnectMode;
    data['ethernetLinkStatus'] = ethernetLinkStatus;
    data['ethernetConnectionStatus'] = ethernetConnectionStatus;
    data['systemOnlineTime'] = systemOnlineTime;
    data['ethernetConnectionIp'] = ethernetConnectionIp;
    data['ethernetConnectionMask'] = ethernetConnectionMask;
    data['ethernetConnectionGateway'] = ethernetConnectionGateway;
    data['ethernetConnectionDns1'] = ethernetConnectionDns1;
    data['ethernetConnectionDns2'] = ethernetConnectionDns2;
    return data;
  }
}