class ScanQualityBean {
  int? code;
  String? message;
  Data? data;
  int? timestamp;

  ScanQualityBean({this.code, this.message, this.data, this.timestamp});

  ScanQualityBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class Data {
  String? wifi5gCurrentChannel;
  List<Band5GHz>? band5GHz;
  String? wifiCurrentChannel;
  String? wifiQuality;
  List<Band24GHz>? band24GHz;

  Data(
      {this.wifi5gCurrentChannel,
      this.band5GHz,
      this.wifiCurrentChannel,
      this.wifiQuality,
      this.band24GHz});

  Data.fromJson(Map<String, dynamic> json) {
    wifi5gCurrentChannel = json['wifi5gCurrentChannel'];
    if (json['band5GHz'] != null) {
      band5GHz = <Band5GHz>[];
      json['band5GHz'].forEach((v) {
        band5GHz!.add(Band5GHz.fromJson(v));
      });
    }
    wifiCurrentChannel = json['wifiCurrentChannel'];
    wifiQuality = json['wifiQuality'];
    if (json['band24GHz'] != null) {
      band24GHz = <Band24GHz>[];
      json['band24GHz'].forEach((v) {
        band24GHz!.add(Band24GHz.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wifi5gCurrentChannel'] = wifi5gCurrentChannel;
    if (band5GHz != null) {
      data['band5GHz'] = band5GHz!.map((v) => v.toJson()).toList();
    }
    data['wifiCurrentChannel'] = wifiCurrentChannel;
    data['wifiQuality'] = wifiQuality;
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

class ChannelResultBean {
  String? event;
  String? sn;
  String? sessionId;
  String? data;

  ChannelResultBean({this.event, this.sn, this.sessionId, this.data});

  ChannelResultBean.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    sn = json['sn'];
    sessionId = json['sessionId'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['sn'] = sn;
    data['sessionId'] = sessionId;
    data['data'] = this.data;
    return data;
  }
}