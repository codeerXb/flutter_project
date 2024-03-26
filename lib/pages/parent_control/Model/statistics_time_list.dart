class AppTimeListBeans {
  String? event;
  String? sn;
  List<Param>? param;

  AppTimeListBeans({this.event, this.sn, this.param});

  AppTimeListBeans.fromJson(Map<String, dynamic> json) {
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
  List<Social>? social;
  List<Video>? video;
  List<ECommerce>? eCommerce;
  List<AppStore>? appStore;
  List<Website>? website;

  Param({this.social, this.video, this.eCommerce, this.appStore, this.website});

  Param.fromJson(Map<String, dynamic> json) {
    if (json['Social'] != null) {
      social = <Social>[];
      json['Social'].forEach((v) {
        social!.add(Social.fromJson(v));
      });
    }
    if (json['Video'] != null) {
      video = <Video>[];
      json['Video'].forEach((v) {
        video!.add(Video.fromJson(v));
      });
    }
    if (json['E-Commerce'] != null) {
      eCommerce = <ECommerce>[];
      json['E-Commerce'].forEach((v) {
        eCommerce!.add(ECommerce.fromJson(v));
      });
    }
    if (json['App Store'] != null) {
      appStore = <AppStore>[];
      json['App Store'].forEach((v) {
        appStore!.add(AppStore.fromJson(v));
      });
    }
    if (json['Website'] != null) {
      website = <Website>[];
      json['Website'].forEach((v) {
        website!.add(Website.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (social != null) {
      data['Social'] = social!.map((v) => v.toJson()).toList();
    }
    if (video != null) {
      data['Video'] = video!.map((v) => v.toJson()).toList();
    }
    if (eCommerce != null) {
      data['E-Commerce'] = eCommerce!.map((v) => v.toJson()).toList();
    }
    if (appStore != null) {
      data['App Store'] = appStore!.map((v) => v.toJson()).toList();
    }
    if (website != null) {
      data['Website'] = website!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Social {
  String? visitTime;
  String? appName;

  Social({this.visitTime, this.appName});

  Social.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['appName'] = appName;
    return data;
  }
}

class Video {
  String? visitTime;
  String? appName;

  Video({this.visitTime, this.appName});

  Video.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['appName'] = appName;
    return data;
  }
}

class ECommerce {
  String? visitTime;
  String? appName;

  ECommerce({this.visitTime, this.appName});

  ECommerce.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['appName'] = appName;
    return data;
  }
}

class AppStore {
  String? visitTime;
  String? appName;

  AppStore({this.visitTime, this.appName});

  AppStore.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['appName'] = appName;
    return data;
  }
}

class Website {
  String? visitTime;
  String? appName;

  Website({this.visitTime, this.appName});

  Website.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['appName'] = appName;
    return data;
  }
}