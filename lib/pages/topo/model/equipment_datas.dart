class EquipmentDatas {
  List<OnlineDeviceTable>? onlineDeviceTable;
  int? max;

  EquipmentDatas({this.onlineDeviceTable, this.max});

  EquipmentDatas.fromJson(Map<String, dynamic> json) {
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
  String? mac;
  String? hostName;
  String? type;

  OnlineDeviceTable(
      {this.id, this.leaseTime, this.iP, this.mac, this.hostName, this.type});

  OnlineDeviceTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaseTime = json['LeaseTime'];
    iP = json['IP'];
    mac = json['MAC'];
    hostName = json['HostName'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['LeaseTime'] = leaseTime;
    data['IP'] = iP;
    data['MAC'] = mac;
    data['HostName'] = hostName;
    data['Type'] = type;
    return data;
  }
}
