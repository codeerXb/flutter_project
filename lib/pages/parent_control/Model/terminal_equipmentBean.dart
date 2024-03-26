class TerminalEquipmentBeans {
  int? code;
  String? message;
  List<EquipmentInfo>? data;

  TerminalEquipmentBeans({this.code, this.message, this.data});

  TerminalEquipmentBeans.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EquipmentInfo>[];
      json['data'].forEach((v) {
        data!.add(EquipmentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EquipmentInfo {
  String? mac;
  String? name;

  EquipmentInfo({this.mac, this.name});

  EquipmentInfo.fromJson(Map<String, dynamic> json) {
    mac = json['mac'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mac'] = mac;
    data['name'] = name;
    return data;
  }
}