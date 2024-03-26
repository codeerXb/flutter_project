class TimeListBeans {
  int? code;
  String? message;
  List<TimeInfoBean>? data;
  int? timestamp;

  TimeListBeans({this.code, this.message, this.data, this.timestamp});

  TimeListBeans.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TimeInfoBean>[];
      json['data'].forEach((v) {
        data!.add(TimeInfoBean.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class TimeInfoBean {
  String? timeStop;
  String? id;
  String? weekdays;
  String? timeStart;

  TimeInfoBean({this.timeStop, this.id, this.weekdays, this.timeStart});

  TimeInfoBean.fromJson(Map<String, dynamic> json) {
    timeStop = json['TimeStop'];
    id = json['id'];
    weekdays = json['Weekdays'];
    timeStart = json['TimeStart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TimeStop'] = timeStop;
    data['id'] = id;
    data['Weekdays'] = weekdays;
    data['TimeStart'] = timeStart;
    return data;
  }
}