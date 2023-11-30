import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
// import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
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
      debugPrint('设备信息：${equipmentData.systemProductModel}');
      return equipmentData;
    }
    debugPrint('设备：$equipmentData');
    return equipmentData;
  }

  //获取云端数据
  Future getACSNode(parameterNames, sn) async {
    Map<String, dynamic> data = {
      'sn': sn,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodes', data: data);
  }

  //设置云端数据
  Future setACSNode(parameterNames, sn) async {
    Map<String, dynamic> data = {
      'sn': sn,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodes', data: data);
  }

  // 设置设备表数据
  Future setSODTable(parameterNames, sn) async {
    Map<String, dynamic> data = {
      'sn': sn,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODTable', data: data);
  }

  //获取设备列表数据
  Future getSODTable(parameterNames, sn) async {
    Map<String, dynamic> data = {
      'sn': sn,
      'param': parameterNames
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODTable', data: data);
  }

  //添加或删除
  Future addOrDeleteObject(objectName, sn) async {
    Map<String, dynamic> data = {
      'sn': sn,
      'param': objectName
    };
    return await App.post('/cpeMqtt/getAndSetDeviceSODNodes', data: data);
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
