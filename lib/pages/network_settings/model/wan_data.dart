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
