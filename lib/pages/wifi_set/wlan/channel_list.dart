// ignore_for_file: camel_case_types

class channelList {
  String? wifiCountryChannelListHT20;
  String? wifiCountryChannelListHT40j;
  String? wifiCountryChannelListHT40;
  String? wifiHtmode;
  String? wifi5gCountryChannelList;

  channelList(
      {this.wifiCountryChannelListHT20,
      this.wifiCountryChannelListHT40j,
      this.wifiCountryChannelListHT40,
      this.wifiHtmode,
      this.wifi5gCountryChannelList});

  channelList.fromJson(Map<String, dynamic> json) {
    wifiCountryChannelListHT20 = json['wifiCountryChannelList_HT20'];
    wifiCountryChannelListHT40j = json['wifiCountryChannelList_HT40+'];
    wifiCountryChannelListHT40 = json['wifiCountryChannelList_HT40-'];
    wifiHtmode = json['wifiHtmode'];
    wifi5gCountryChannelList = json['wifi5gCountryChannelList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiCountryChannelList_HT20'] = wifiCountryChannelListHT20;
    data['wifiCountryChannelList_HT40+'] = wifiCountryChannelListHT40j;
    data['wifiCountryChannelList_HT40-'] = wifiCountryChannelListHT40;
    data['wifiHtmode'] = wifiHtmode;
    data['wifi5gCountryChannelList'] = wifi5gCountryChannelList;
    return data;
  }
}
