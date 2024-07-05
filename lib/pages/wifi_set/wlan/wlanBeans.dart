class wlanBean {
  Data? data;

  wlanBean({this.data});

  wlanBean.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? wifiEnable;
  String? wifiMode;
  String? wifiHtmode;
  String? wifiChannel;
  String? wifiTxpower;
  String? wifiCountryChannelListHT20;
  String? wifiCountryChannelListHT40;
  String? wifiCountryChannelList;

  Data(
      {this.wifiEnable,
      this.wifiMode,
      this.wifiHtmode,
      this.wifiChannel,
      this.wifiTxpower,
      this.wifiCountryChannelListHT20,
      this.wifiCountryChannelListHT40,
      this.wifiCountryChannelList
      });

  Data.fromJson(Map<String, dynamic> json) {
    wifiEnable = json['wifiEnable'];
    wifiMode = json['wifiMode'];
    wifiHtmode = json['wifiHtmode'];
    wifiChannel = json['wifiChannel'];
    wifiTxpower = json['wifiTxpower'];
    wifiCountryChannelListHT20 = json['wifiCountryChannelList_HT20'];
    wifiCountryChannelListHT40 = json['wifiCountryChannelList_HT40'];
    wifiCountryChannelList = json['wifiCountryChannelList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiEnable'] = wifiEnable;
    data['wifiMode'] = wifiMode;
    data['wifiHtmode'] = wifiHtmode;
    data['wifiChannel'] = wifiChannel;
    data['wifiTxpower'] = wifiTxpower;
    data['wifiCountryChannelList_HT20'] = wifiCountryChannelListHT20;
    data['wifiCountryChannelList_HT40'] = wifiCountryChannelListHT40;
    data['wifiCountryChannelList'] = wifiCountryChannelList;
    return data;
  }
}