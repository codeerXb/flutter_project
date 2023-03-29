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

  // getTREquinfoDatas() async {
  //   Map<String, dynamic> data = {
  //     'deviceId': 'RS621A00211700113',
  //     'name': 'getParameterValues',
  //     'parameterNames': [
  //       "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.ProductModel",
  //       "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.HardVersion",
  //       "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.SoftwareVersion",
  //       "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.UBOOTVersion",
  //       "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.SerialNumber",
  //       "InternetGatewayDevice.WEB_GUI.Overview.ModuleInfo.IMEI",
  //       "InternetGatewayDevice.WEB_GUI.Overview.ModuleInfo.IMSI",
  //       "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.MACAddress",
  //       "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.IPAddress",
  //       "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.SubnetMask",
  //       "InternetGatewayDevice.WEB_GUI.Overview.SystemInfo.RunTime"
  //     ]
  //   };
  //   var res = await App.post(
  //       '${BaseConfig.cloudBaseUrl}/platform/tr069/getParameterValues',
  //       data: data);
  //   return res;
  // }
}
