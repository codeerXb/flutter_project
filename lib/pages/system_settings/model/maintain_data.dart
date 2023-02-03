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

// 重启定时 获取
class MaintainTrestsetData {
  String? systemScheduleRebootEnable;
  String? systemScheduleRebootDays;
  String? systemScheduleRebootTime;

  MaintainTrestsetData(
      {this.systemScheduleRebootEnable,
      this.systemScheduleRebootDays,
      this.systemScheduleRebootTime});

  MaintainTrestsetData.fromJson(Map<String, dynamic> json) {
    systemScheduleRebootEnable = json['systemScheduleRebootEnable'];
    systemScheduleRebootDays = json['systemScheduleRebootDays'];
    systemScheduleRebootTime = json['systemScheduleRebootTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['systemScheduleRebootEnable'] = systemScheduleRebootEnable;
    data['systemScheduleRebootDays'] = systemScheduleRebootDays;
    data['systemScheduleRebootTime'] = systemScheduleRebootTime;
    return data;
  }
}
