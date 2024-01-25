
class mqtt_model {
  Data? data;

  mqtt_model({this.data});

  mqtt_model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? topic;
  String? msg;
  Clos? clos;
  List<String>? products;

  Data({this.topic, this.msg, this.clos, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    msg = json['msg'];
    clos = json['clos'] != null ? new Clos.fromJson(json['clos']) : null;
    products = json['products'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['msg'] = this.msg;
    if (this.clos != null) {
      data['clos'] = this.clos!.toJson();
    }
    data['products'] = this.products;
    return data;
  }
}

class Clos {
  String? num;
  String? name;

  Clos({this.num, this.name});

  Clos.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['name'] = this.name;
    return data;
  }
}