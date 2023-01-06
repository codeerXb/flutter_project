class MaintainData {
  bool? success;

  MaintainData({this.success});

  MaintainData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}
