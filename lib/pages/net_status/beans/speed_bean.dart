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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['sn'] = sn;
    data['sessionId'] = sessionId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['download'] = download;
    data['upload'] = upload;
    data['ping'] = ping;
    data['timestamp'] = timestamp;
    return data;
  }
}