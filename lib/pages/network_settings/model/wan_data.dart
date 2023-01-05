class WanSettingData {
  String? networkWanSettingsMode;

  WanSettingData({this.networkWanSettingsMode});

  WanSettingData.fromJson(Map<String, dynamic> json) {
    networkWanSettingsMode = json['networkWanSettingsMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['networkWanSettingsMode'] = networkWanSettingsMode;
    return data;
  }
}

// 网络模式
class WanNetworkModel {
  bool? success;

  WanNetworkModel({this.success});

  WanNetworkModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}
