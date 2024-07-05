class AccessControlBean {
  String? event;
  String? sn;
  String? sessionId;
  Data? data;

  AccessControlBean({this.event, this.sn, this.sessionId, this.data});

  AccessControlBean.fromJson(Map<String, dynamic> json) {
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
  List<WiFiAccessTable>? wiFiAccessTable;
  int? max;

  Data({this.wiFiAccessTable, this.max});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['WiFiAccessTable'] != null) {
      wiFiAccessTable = <WiFiAccessTable>[];
      json['WiFiAccessTable'].forEach((v) {
        wiFiAccessTable!.add(WiFiAccessTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wiFiAccessTable != null) {
      data['WiFiAccessTable'] =
          wiFiAccessTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class WiFiAccessTable {
  int? id;
  String? mac;

  WiFiAccessTable({this.id, this.mac});

  WiFiAccessTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mac = json['MAC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['MAC'] = mac;
    return data;
  }
}