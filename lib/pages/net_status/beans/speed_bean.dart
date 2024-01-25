class SpeedModel {
  String? event;
  String? sn;
  String? sessionId;
  Data? data;

  SpeedModel({this.event, this.sn, this.sessionId, this.data});

  SpeedModel.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    sn = json['sn'];
    sessionId = json['sessionId'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['sn'] = this.sn;
    data['sessionId'] = this.sessionId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  double? download;
  double? upload;
  double? ping;
  String? timestamp;

  Data({this.download, this.upload, this.ping, this.timestamp});

  Data.fromJson(Map<String, dynamic> json) {
    download = json['download'];
    upload = json['upload'];
    ping = json['ping'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download'] = this.download;
    data['upload'] = this.upload;
    data['ping'] = this.ping;
    data['timestamp'] = this.timestamp;
    return data;
  }
}