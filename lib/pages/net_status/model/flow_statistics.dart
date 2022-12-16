class FlowStatistics {
  List<FlowTable>? flowTable;
  int? max;

  FlowStatistics({this.flowTable, this.max});

  FlowStatistics.fromJson(Map<String, dynamic> json) {
    if (json['FlowTable'] != null) {
      flowTable = <FlowTable>[];
      json['FlowTable'].forEach((v) {
        flowTable!.add(FlowTable.fromJson(v));
      });
    }
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (flowTable != null) {
      data['FlowTable'] = flowTable!.map((v) => v.toJson()).toList();
    }
    data['max'] = max;
    return data;
  }
}

class FlowTable {
  int? id;
  String? name;
  String? recvBytes;
  String? recvPackets;
  String? recvErrs;
  String? recvDrop;
  String? sendBytes;
  String? sendPackets;
  String? sendErrs;
  String? sendDrop;

  FlowTable(
      {this.id,
      this.name,
      this.recvBytes,
      this.recvPackets,
      this.recvErrs,
      this.recvDrop,
      this.sendBytes,
      this.sendPackets,
      this.sendErrs,
      this.sendDrop});

  FlowTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    recvBytes = json['RecvBytes'];
    recvPackets = json['RecvPackets'];
    recvErrs = json['RecvErrs'];
    recvDrop = json['RecvDrop'];
    sendBytes = json['SendBytes'];
    sendPackets = json['SendPackets'];
    sendErrs = json['SendErrs'];
    sendDrop = json['SendDrop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Name'] = name;
    data['RecvBytes'] = recvBytes;
    data['RecvPackets'] = recvPackets;
    data['RecvErrs'] = recvErrs;
    data['RecvDrop'] = recvDrop;
    data['SendBytes'] = sendBytes;
    data['SendPackets'] = sendPackets;
    data['SendErrs'] = sendErrs;
    data['SendDrop'] = sendDrop;
    return data;
  }
}
