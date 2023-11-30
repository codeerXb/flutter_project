class Wan_status_table_bean {
  List<Data>? data;

  Wan_status_table_bean({this.data});

  Wan_status_table_bean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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