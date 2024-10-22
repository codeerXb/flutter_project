import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
// import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import './model/equipment_data.dart';
import '../../../core/utils/string_util.dart';

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
      debugPrint('设备信息：${equipmentData.systemProductModel}');
      return equipmentData;
    }
    debugPrint('设备：$equipmentData');
    return equipmentData;
  }

  //获取云端数据
  Future getACSNode(parameterNames, sn) async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    Map<String, dynamic> data = {
      'sn': sn,
      "sessionId" : sessionIdCha,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodesOfApp', data: data);
  }

  //设置云端数据
  Future setACSNode(parameterNames, sn) async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    Map<String, dynamic> data = {
      'sn': sn,
      "sessionId" : sessionIdCha,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodesOfApp', data: data);
  }

  // 设置设备表数据
  Future setSODTable(parameterNames, sn) async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    Map<String, dynamic> data = {
      'sn': sn,
      "sessionId" : sessionIdCha,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODTableOfApp', data: data);
  }

  //获取设备列表数据
  Future getSODTable(parameterNames, sn) async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    Map<String, dynamic> data = {
      'sn': sn,
      "sessionId" : sessionIdCha,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODTableOfApp', data: data);
  }

  //添加或删除
  Future addOrDeleteObject(objectName, sn) async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    Map<String, dynamic> data = {
      'sn': sn,
      "sessionId" : sessionIdCha,
      'param': objectName
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodesOfApp', data: data);
  }

  //修改
  Future putObject(objectName) async {
    Map<String, dynamic> data = objectName;
    return await App.put('/platform/appCustomer/update', data: data);
  }

  //file
  // Future fileObject(objectName) async {
  //   Map<String, dynamic> data = objectName;
  //   return await App.post('/file/upload', data: data);
  // }
  //file
  // Future fileObject(objectName) async {
  //   FormData formData = FormData.fromMap({'file': objectName});
  //   return await App.post('/file/upload', data: formData);
  // }
}
