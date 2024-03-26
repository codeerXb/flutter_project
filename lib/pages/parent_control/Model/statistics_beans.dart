class StatisticsBeans {
  String? event;
  String? sn;
  StatisticsTimes? param;

  StatisticsBeans({this.event, this.sn, this.param});

  StatisticsBeans.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    sn = json['sn'];
    param = json['param'] != null ?  StatisticsTimes.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['sn'] = sn;
    if (param != null) {
      data['param'] = param!.toJson();
    }
    return data;
  }
}

class StatisticsTimes {
  String? totalVisitTime;
  List<VisitTimeList>? visitTimeList;

  StatisticsTimes({this.totalVisitTime,this.visitTimeList});

  StatisticsTimes.fromJson(Map<String, dynamic> json) {
    totalVisitTime = json['totalVisitTime'];
    if (json['visitTimeList'] != null) {
      visitTimeList = <VisitTimeList>[];
      json['visitTimeList'].forEach((v) {
        visitTimeList!.add(VisitTimeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalVisitTime'] = totalVisitTime;
    if (visitTimeList != null) {
      data['visitTimeList'] =
          visitTimeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitTimeList {
  String? visitTime;
  String? typeName;

  VisitTimeList({this.visitTime, this.typeName});

  VisitTimeList.fromJson(Map<String, dynamic> json) {
    visitTime = json['visitTime'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitTime'] = visitTime;
    data['typeName'] = typeName;
    return data;
  }
}
