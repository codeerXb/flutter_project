class DnsSettingData {
  String? lteManualDns1;
  String? lteManualDns2;

  DnsSettingData({this.lteManualDns1, this.lteManualDns2});

  DnsSettingData.fromJson(Map<String, dynamic> json) {
    lteManualDns1 = json['lteManualDns1'];
    lteManualDns2 = json['lteManualDns2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lteManualDns1'] = lteManualDns1;
    data['lteManualDns2'] = lteManualDns2;
    return data;
  }
}
