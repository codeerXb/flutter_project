class AccessDatas {
  bool? success;

  AccessDatas({this.success});

  AccessDatas.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}

class AccessListDatas {
  List<FwParentControlTable>? fwParentControlTable;
  int? max;

  AccessListDatas({this.fwParentControlTable, this.max});

  AccessListDatas.fromJson(Map<String, dynamic> json) {
    if (json['FwParentControlTable'] != null) {
      fwParentControlTable = <FwParentControlTable>[];
      json['FwParentControlTable'].forEach((v) {
        fwParentControlTable!.add(FwParentControlTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fwParentControlTable != null) {
      data['FwParentControlTable'] =
          fwParentControlTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class FwParentControlTable {
  int? id;
  String? enable;
  String? name;
  String? weekdays;
  String? timeStart;
  String? timeStop;
  String? host;
  String? target;

  FwParentControlTable(
      {this.id,
      this.enable,
      this.name,
      this.weekdays,
      this.timeStart,
      this.timeStop,
      this.host,
      this.target});

  FwParentControlTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enable = json['Enable'];
    name = json['Name'];
    weekdays = json['Weekdays'];
    timeStart = json['TimeStart'];
    timeStop = json['TimeStop'];
    host = json['Host'];
    target = json['Target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Enable'] = enable;
    data['Name'] = name;
    data['Weekdays'] = weekdays;
    data['TimeStart'] = timeStart;
    data['TimeStop'] = timeStop;
    data['Host'] = host;
    data['Target'] = target;
    return data;
  }
}
