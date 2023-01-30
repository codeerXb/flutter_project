class ODUData {
  int? cmd;
  int? param1;
  int? param2;
  List<DataTable>? dataTable;

  ODUData({this.cmd, this.param1, this.param2, this.dataTable});

  ODUData.fromJson(Map<String, dynamic> json) {
    cmd = json['cmd'];
    param1 = json['param1'];
    param2 = json['param2'];
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
    data['param1'] = param1;
    data['param2'] = param2;
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
