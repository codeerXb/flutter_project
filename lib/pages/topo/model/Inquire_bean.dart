class InquireInfoBean {
  int? code;
  String? message;
  Data? data;

  InquireInfoBean({this.code, this.message, this.data});

  InquireInfoBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? account;
  String? nickname;
  List<CustomerCpeVOList>? customerCpeVOList;

  Data({this.id, this.account, this.nickname, this.customerCpeVOList});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    account = json['account'];
    nickname = json['nickname'];
    if (json['customerCpeVOList'] != null) {
      customerCpeVOList = <CustomerCpeVOList>[];
      json['customerCpeVOList'].forEach((v) {
        customerCpeVOList!.add(CustomerCpeVOList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['account'] = account;
    data['nickname'] = nickname;
    if (customerCpeVOList != null) {
      data['customerCpeVOList'] =
          customerCpeVOList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerCpeVOList {
  String? deviceSn;
  String? type;

  CustomerCpeVOList({this.deviceSn, this.type});

  CustomerCpeVOList.fromJson(Map<String, dynamic> json) {
    deviceSn = json['deviceSn'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceSn'] = deviceSn;
    data['type'] = type;
    return data;
  }
}