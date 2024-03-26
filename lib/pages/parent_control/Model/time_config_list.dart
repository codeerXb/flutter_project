class TimeConfigListBeans {
  String? event;
  String? sn;
  List<TimeRuleBean>? param;

  TimeConfigListBeans({this.event, this.sn, this.param});

  TimeConfigListBeans.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    sn = json['sn'];
    if (json['param'] != null) {
      param = <TimeRuleBean>[];
      json['param'].forEach((v) {
        param!.add(TimeRuleBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['sn'] = sn;
    if (param != null) {
      data['param'] = param!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeRuleBean {
  String? deviceName;
  String? mac;
  List<DeviceTimeRule>? deviceTimeRule;

  TimeRuleBean({this.deviceName, this.mac, this.deviceTimeRule});

  TimeRuleBean.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    mac = json['mac'];
    if (json['deviceTimeRule'] != null) {
      deviceTimeRule = <DeviceTimeRule>[];
      json['deviceTimeRule'].forEach((v) {
        deviceTimeRule!.add(DeviceTimeRule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['mac'] = mac;
    if (deviceTimeRule != null) {
      data['deviceTimeRule'] =
          deviceTimeRule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeviceTimeRule {
  int? id;
  String? timeStart;
  String? timeStop;
  String? weekdays;

  DeviceTimeRule({this.id, this.timeStart, this.timeStop, this.weekdays});

  DeviceTimeRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeStart = json['TimeStart'];
    timeStop = json['TimeStop'];
    weekdays = json['Weekdays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TimeStart'] = timeStart;
    data['TimeStop'] = timeStop;
    data['Weekdays'] = weekdays;
    return data;
  }
}