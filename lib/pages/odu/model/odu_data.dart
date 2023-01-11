class ODUData {
  ODUTransmission? oDUTransmission;

  ODUData({this.oDUTransmission});

  ODUData.fromJson(Map<String, dynamic> json) {
    oDUTransmission = json['ODUTransmission'] != null
        ? ODUTransmission.fromJson(json['ODUTransmission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (oDUTransmission != null) {
      data['ODUTransmission'] = oDUTransmission!.toJson();
    }
    return data;
  }
}

class ODUTransmission {
  int? cmd;
  int? seq;
  int? param1;
  int? param2;
  int? param3;
  List<DataTable>? dataTable;

  ODUTransmission(
      {this.cmd,
      this.seq,
      this.param1,
      this.param2,
      this.param3,
      this.dataTable});

  ODUTransmission.fromJson(Map<String, dynamic> json) {
    cmd = json['cmd'];
    seq = json['seq'];
    param1 = json['param1'];
    param2 = json['param2'];
    param3 = json['param3'];
    if (json['data_table'] != null) {
      dataTable = <DataTable>[];
      json['data_table'].forEach((v) {
        dataTable!.add(DataTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmd'] = cmd;
    data['seq'] = seq;
    data['param1'] = param1;
    data['param2'] = param2;
    data['param3'] = param3;
    if (dataTable != null) {
      data['data_table'] = dataTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataTable {
  int? degree;
  int? sinr;

  DataTable({this.degree, this.sinr});

  DataTable.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    sinr = json['sinr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['degree'] = degree;
    data['sinr'] = sinr;
    return data;
  }
}
