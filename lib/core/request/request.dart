import 'dart:convert';

import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import './model/equipment_data.dart';

class Request {
  Future<EquipmentData> getEquipmentData() async {
    EquipmentData equipmentData = EquipmentData();
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]'
    };
    var res = await XHttp.get('/pub/pub_data.html', data);
    var d = json.decode(res.toString());
    if (equipmentData.systemVersionSn == null ||
        equipmentData.systemVersionSn !=
            EquipmentData.fromJson(d).systemVersionSn) {
      equipmentData = EquipmentData.fromJson(d);
      print('设备正确');
      print('设备信息：${equipmentData.systemProductModel}');
      return equipmentData;
    }
    print('设备：$equipmentData');
    return equipmentData;
  }

  getTRUsedFlow(parameterNames, sn) async {
    Map<String, dynamic> data = {
      'deviceId': sn,
      'name': 'getParameterValues',
      'parameterNames': parameterNames
    };
    var res = await App.post(
        '${BaseConfig.cloudBaseUrl}/platform/tr069/getParameterValues',
        data: data);
    return res;
  }
}
