class ScanQualityBean {
  Param? data;

  ScanQualityBean({this.data});

  ScanQualityBean.fromJson(Map<String, dynamic> json) {
    data = json['param'] != null ? Param.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['param'] = this.data!.toJson();
    }
    return data;
  }
}

class Param {
  String? wifiQuality;
  String? wifiCurrentChannel;
  String? wifi5gCurrentChannel;
  List<Band5GHz>? band5GHz;
  List<Band24GHz>? band24GHz;

  Param({this.wifiQuality,this.band5GHz, this.band24GHz,this.wifiCurrentChannel,this.wifi5gCurrentChannel});
// result = json['result'].map<result>((j) => result.fromjson(j).tolist();
  Param.fromJson(Map<String, dynamic> json) {
    wifiQuality = json['wifiQuality'];
    wifiCurrentChannel = json['wifiCurrentChannel'];
    wifi5gCurrentChannel = json['wifi5gCurrentChannel'];
    if (json['band5GHz'] != null) {
      
      // band5GHz = json['band5GHz'].map<Band5GHz>((j) => Band5GHz.fromJson(j)).tolist();
      band5GHz = <Band5GHz>[];
      json['band5GHz'].forEach((v) {
        band5GHz!.add(Band5GHz.fromJson(v));
      });
    }
    if (json['band24GHz'] != null) {
      // band24GHz = json['band24GHz'].map<Band24GHz>((j) => Band24GHz.fromJson(j)).tolist();
      band24GHz = <Band24GHz>[];
      json['band24GHz'].forEach((v) {
        band24GHz!.add(Band24GHz.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifiQuality'] = wifiQuality;
    data['wifiCurrentChannel'] = wifiCurrentChannel;
    data['wifi5gCurrentChannel'] = wifi5gCurrentChannel;
    if (band5GHz != null) {
      data['band5GHz'] = band5GHz!.map((v) => v.toJson()).toList();
    }
    if (band24GHz != null) {
      data['band24GHz'] = band24GHz!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Band5GHz {
  String? channel;
  String? quality;

  Band5GHz({this.channel, this.quality});

  Band5GHz.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    quality = json['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channel;
    data['quality'] = quality;
    return data;
  }
}

class Band24GHz {
  String? channel;
  String? quality;

  Band24GHz({this.channel, this.quality});

  Band24GHz.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    quality = json['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channel;
    data['quality'] = quality;
    return data;
  }
}