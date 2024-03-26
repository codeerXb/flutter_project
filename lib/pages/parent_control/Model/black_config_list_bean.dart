class BlackListConfigBeans {
  String? event;
  String? sn;
  List<Param>? param;

  BlackListConfigBeans({this.event, this.sn, this.param});

  BlackListConfigBeans.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    sn = json['sn'];
    if (json['param'] != null) {
      param = <Param>[];
      json['param'].forEach((v) {
        param!.add(Param.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['sn'] = sn;
    if (param != null) {
      data['param'] = param!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Param {
  String? deviceName;
  String? mac;
  DeviceRule? deviceRule;

  Param({this.deviceName, this.mac, this.deviceRule});

  Param.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    mac = json['mac'];
    deviceRule = json['deviceRule'] != null
        ? DeviceRule.fromJson(json['deviceRule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['mac'] = mac;
    if (deviceRule != null) {
      data['deviceRule'] = deviceRule!.toJson();
    }
    return data;
  }
}

class DeviceRule {
  List<CategoryInfo>? websiteList;
  List<CategoryInfo>? appStore;
  List<CategoryInfo>? video;
  List<CategoryInfo>? eCommercePortalAccessTimes;
  List<CategoryInfo>? socialMedia;

  DeviceRule(
      {this.websiteList,
      this.appStore,
      this.video,
      this.eCommercePortalAccessTimes,this.socialMedia});

  DeviceRule.fromJson(Map<String, dynamic> json) {
    if (json['Website List'] != null) {
      websiteList = <CategoryInfo>[];
      json['Website List'].forEach((v) {
        websiteList!.add(CategoryInfo.fromJson(v));
      });
    }
    if (json['App Store'] != null) {
      appStore = <CategoryInfo>[];
      json['App Store'].forEach((v) {
        appStore!.add(CategoryInfo.fromJson(v));
      });
    }
    if (json['Video'] != null) {
      video = <CategoryInfo>[];
      json['Video'].forEach((v) {
        video!.add(CategoryInfo.fromJson(v));
      });
    }
    if (json['E-Commerce Portal Access Times'] != null) {
      eCommercePortalAccessTimes = <CategoryInfo>[];
      json['E-Commerce Portal Access Times'].forEach((v) {
        eCommercePortalAccessTimes!
            .add(CategoryInfo.fromJson(v));
      });
    }
    if (json['Social Media'] != null) {
      socialMedia = <CategoryInfo>[];
      json['Social Media'].forEach((v) {
        socialMedia!.add(CategoryInfo.fromJson(v));
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
    if (video != null) {
      data['Video'] = video!.map((v) => v.toJson()).toList();
    }
    if (eCommercePortalAccessTimes != null) {
      data['E-Commerce Portal Access Times'] =
          eCommercePortalAccessTimes!.map((v) => v.toJson()).toList();
    }
    if (socialMedia != null) {
      data['Social Media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryInfo {
  String? appName;
  String? url;

  CategoryInfo({this.appName, this.url});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appName'] = appName;
    data['url'] = url;
    return data;
  }
}

// class AppStore {
//   String? appName;
//   String? url;

//   AppStore({this.appName, this.url});

//   AppStore.fromJson(Map<String, dynamic> json) {
//     appName = json['appName'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['appName'] = appName;
//     data['url'] = url;
//     return data;
//   }
// }