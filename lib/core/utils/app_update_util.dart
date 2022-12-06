import 'dart:convert';
import 'dart:io';

import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:package_info/package_info.dart';

/// app更新
class AppUpdateUtils{

  /// 将返回值转换为UpdateEntity
  _convertMap2UpdateEntity(Map jsonData) async {
    var versionCode = jsonData["versionCode"].replaceAll('.', '');
    var updateText = jsonData["updateContent"].split('。');
    var updateContent = '';
    updateText.forEach((t) {
      updateContent += '\r\n$t';
    });

    UpdateEntity updateEntity = UpdateEntity(
        isForce: jsonData["isForce"] == 1,
        hasUpdate: true,
        isIgnorable: false,
        versionCode: int.parse(versionCode),
        versionName: jsonData["versionName"],
        updateContent: updateContent,
        downloadUrl: jsonData["downloadUrl"],
        apkSize: jsonData["apkSize"]
    );
    return updateEntity;
  }

  /// 初始化插件
  Future<dynamic> _initXUpdate() async {
    FlutterXUpdate.init(
        //是否输出日志
        debug: true,
        //是否使用post请求
        isPost: true,
        //post请求是否是上传json
        isPostJson: true,
        //是否开启自动模式
        isWifiOnly: false,
        ///是否开启自动模式
        isAutoMode: false,
        //需要设置的公共参数
        supportSilentInstall: false,
        //在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
        enableRetry: false
    ).then((value) {
      print("初始化成功: $value");
    }).catchError((error) {
      print(error);
    });
    FlutterXUpdate.setUpdateHandler(
        onUpdateError: (message) async {
          print("初始化成功: $message");
        }, onUpdateParse: (res) async {
      //这里是自定义json解析
      Map jsonData = json.decode(res!);
      return _convertMap2UpdateEntity(jsonData);
    });
  }

  /// 检查是否需要版本更新
  updateApp({bool fromHome = true}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    // 这个地址需要修改一下
    XHttp.post('https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_test.json').then((data){
      String remoteVersion = data['data']['version'];
      if(Platform.isIOS){
        remoteVersion = data['data']['iosVersion'];
      }
      if(_compareVersion(remoteVersion, localVersion) == 1){
        if(Platform.isAndroid){
          _appUpdate(data['data']);
        } else if(Platform.isIOS){
          // 跳转应用商店
        } else {
          ToastUtils.toast("暂不支持该系统的移动设备！");
        }
      } else if(!fromHome){
        ToastUtils.toast("当前已是最新版本！");
      }
    });
  }

  _appUpdate(versionData) async{
    await _initXUpdate();
    FlutterXUpdate.updateByInfo(updateEntity: _convertMap2UpdateEntity(versionData));
  }

  ///比较本版号大小
  ///version1版本号大于version2 返回 1
  ///version1版本号小于version2 返回 -1
  ///version1版本号等于version2 返回 0
  int _compareVersion(String version1,String version2){
    List<String> xArr = version1.split('.');
    List<String> yArr = version2.split('.');
    int len = xArr.length > yArr.length ? xArr.length : yArr.length;
    for(int i = 0;i < len;i++){
      String xItem = "0";
      String yItem = "0";
      try{
        xItem = xArr[i];
      } catch(e){
        return -1;
      }
      try{
        yItem = yArr[i];
      } catch(e){
        return 1;
      }
      if(int.parse(xItem) > int.parse(yItem)){
        return 1;
      }else if(int.parse(xItem) < int.parse(yItem)){
        return -1;
      }
    }
    return 0;
  }
}