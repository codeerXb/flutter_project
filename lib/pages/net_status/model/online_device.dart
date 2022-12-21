class OnlineDevice {
  List<OnlineDeviceTable>? onlineDeviceTable;
  int? max;

  OnlineDevice({this.onlineDeviceTable, this.max});

  OnlineDevice.fromJson(Map<String, dynamic> json) {
    if (json['OnlineDeviceTable'] != null) {
      onlineDeviceTable = <OnlineDeviceTable>[];
      json['OnlineDeviceTable'].forEach((v) {
        onlineDeviceTable!.add(OnlineDeviceTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (onlineDeviceTable != null) {
      data['OnlineDeviceTable'] =
          onlineDeviceTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class OnlineDeviceTable {
  int? id;
  String? leaseTime;
  String? iP;
  String? mAC;
  String? hostName;
  String? type;

  OnlineDeviceTable(
      {this.id, this.leaseTime, this.iP, this.mAC, this.hostName, this.type});

  OnlineDeviceTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaseTime = json['LeaseTime'];
    iP = json['IP'];
    mAC = json['MAC'];
    hostName = json['HostName'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['LeaseTime'] = leaseTime;
    data['IP'] = iP;
    data['MAC'] = mAC;
    data['HostName'] = hostName;
    data['Type'] = type;
    return data;
  }
}
