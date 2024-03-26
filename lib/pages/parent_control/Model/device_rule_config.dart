class DeviceRuleBeans {
  int? code;
  String? message;
  Data? data;

  DeviceRuleBeans({this.code, this.message, this.data });

  DeviceRuleBeans.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? deviceName;
  DeviceRule? deviceRule;
  String? mac;

  Data({this.deviceName, this.deviceRule, this.mac});

  Data.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    deviceRule = json['deviceRule'] != null
        ? DeviceRule.fromJson(json['deviceRule'])
        : null;
    mac = json['mac'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    if (deviceRule != null) {
      data['deviceRule'] = deviceRule!.toJson();
    }
    data['mac'] = mac;
    return data;
  }
}

class DeviceRule {
  List<ApplicationInfo>? websiteList;
  List<ApplicationInfo>? appStore;
  List<ApplicationInfo>? socialMedia;
  List<ApplicationInfo>? video;
  List<ApplicationInfo>? eCommercePortalAccessTimes;

  DeviceRule(
      {this.websiteList,
      this.appStore,
      this.socialMedia,
      this.video,
      this.eCommercePortalAccessTimes});

  DeviceRule.fromJson(Map<String, dynamic> json) {
    if (json['Website List'] != null) {
      websiteList = <ApplicationInfo>[];
      json['Website List'].forEach((v) {
        websiteList!.add(ApplicationInfo.fromJson(v));
      });
    }
    if (json['App Store'] != null) {
      appStore = <ApplicationInfo>[];
      json['App Store'].forEach((v) {
        appStore!.add(ApplicationInfo.fromJson(v));
      });
    }
    if (json['Social Media'] != null) {
      socialMedia = <ApplicationInfo>[];
      json['Social Media'].forEach((v) {
        socialMedia!.add(ApplicationInfo.fromJson(v));
      });
    }
    if (json['Video'] != null) {
      video = <ApplicationInfo>[];
      json['Video'].forEach((v) {
        video!.add(ApplicationInfo.fromJson(v));
      });
    }
    if (json['E-Commerce Portal Access Times'] != null) {
      eCommercePortalAccessTimes = <ApplicationInfo>[];
      json['E-Commerce Portal Access Times'].forEach((v) {
        eCommercePortalAccessTimes!
            .add(ApplicationInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (websiteList != null) {
      data['Website List'] = websiteList!.map((v) => v.toJson()).toList();
    }
    if (appStore != null) {
      data['App Store'] = appStore!.map((v) => v.toJson()).toList();
    }
    if (socialMedia != null) {
      data['Social Media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    if (video != null) {
      data['Video'] = video!.map((v) => v.toJson()).toList();
    }
    if (eCommercePortalAccessTimes != null) {
      data['E-Commerce Portal Access Times'] =
          eCommercePortalAccessTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApplicationInfo {
  String? selectedFlag;
  String? appName;
  String? url;

  ApplicationInfo({this.selectedFlag, this.appName, this.url});

  ApplicationInfo.fromJson(Map<String, dynamic> json) {
    selectedFlag = json['selectedFlag'];
    appName = json['appName'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['selectedFlag'] = selectedFlag;
    data['appName'] = appName;
    data['url'] = url;
    return data;
  }
}