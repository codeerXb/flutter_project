import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

class UpdaterPage extends StatefulWidget {
  final Widget child;

  const UpdaterPage(this.child, {super.key});

  @override
  UpdatePagerState createState() => UpdatePagerState();
}

class UpdatePagerState extends State<UpdaterPage> {
  var _serviceVersionCode;
  int timeStart = 0;
  var _serviceAppStatus;
  var _currentVersionCode;
  final Uri androidUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.Codium.CodiumHome');
  final Uri iosUrl =
      Uri.parse('https://apps.apple.com/us/app/wi-fi-home/id6477293583');
  late Timer timer;

  @override
  void initState() {
    super.initState();

    sharedGetData('app_version', String).then(((res) {
      if (res != null) {
        if (mounted) {
          setState(() {
            _serviceVersionCode = res;
            debugPrint("远程版本$_serviceVersionCode");
          });
        }
      }
    }));

    sharedGetData('isupdatedApp', int).then(((res) {
      if (res != null) {
        if (mounted) {
          setState(() {
            _serviceAppStatus = res;
            debugPrint("远程开关状态$_serviceAppStatus");
          });
        }
      }
    }));

    sharedGetData('currentAppVersion', String).then(((res) {
      if (res != null) {
        if (mounted) {
          setState(() {
            _currentVersionCode = res;
            debugPrint("本地版本$_currentVersionCode");
          });
        }
      }
    }));

    sharedGetData('timeStart', int).then(((res) {
      if (res != null) timeStart = res as int;
    }));

    timer = Timer(const Duration(seconds: 2), () {
      //每次打开APP获取当前时间戳
      var timeEnd = DateTime.now().millisecondsSinceEpoch;
      //获取"Later"保存的时间戳

      debugPrint("时间间隔是:${timeEnd - timeStart}");
      if (timeStart == 0) {
        //第一次打开APP时执行"版本更新"的网络请求
        _getNewVersionAPP();
      } else if (timeStart != 0 && timeEnd - timeStart >= 24 * 60 * 60 * 1000) {
        //如果新旧时间戳的差大于或等于一天，执行网络请求
        _getNewVersionAPP();
      }
    });
  }

  //执行版本更新的网络请求
  _getNewVersionAPP() {
    final isNew = isNewVersion(_serviceVersionCode, _currentVersionCode);
    debugPrint("当前的版本是否需要更新:$isNew");
    if (isNew && _serviceAppStatus == 1) {
      _showNewVersionAppDialog();
    }
  }

  // 版本号对比方法
  bool isNewVersion(String netVersion, String localAppVersion) {
    debugPrint("本地当前版本是:$localAppVersion,远程版本:$netVersion");
    if (netVersion.isEmpty || localAppVersion.isEmpty) return false;
    try {
      List<String> arr1 = netVersion.split('.');
      List<String> arr2 = localAppVersion.split('.');
      int length1 = arr1.length;
      int length2 = arr2.length;
      int minLength = length1 < length2 ? length1 : length2;
      int i = 0;
      for (i; i < minLength; i++) {
        int a = int.parse(arr1[i]);
        int b = int.parse(arr2[i]);
        if (a > b) {
          return true;
        } else if (a < b) {
          return false;
        }
      }
      if (length1 > length2) {
        for (int j = i; j < length1; j++) {
          if (int.parse(arr1[j]) != 0) {
            return true;
          }
        }
        return false;
      } else if (length1 < length2) {
        for (int j = i; j < length2; j++) {
          if (int.parse(arr2[j]) != 0) {
            return false;
          }
        }
        return false;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  // 弹出"版本更新"对话框
  Future<void> _showNewVersionAppDialog() async {
    if (Platform.isAndroid) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // new Image.asset("images/ic_launcher_icon.png",
                  //     height: 35.0, width: 35.0),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
                      child: Text("检测到有新版本",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0)))
                ],
              ),
              content: Text(
                "当前版本是:$_currentVersionCode,新版本是:$_serviceVersionCode,是否需要更新?",
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("later",
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    var timeStart = DateTime.now().millisecondsSinceEpoch;
                    sharedAddAndUpdate("timeStart", int, timeStart); //保存当前的时间戳
                  },
                ),
                ElevatedButton(
                  child: const Text("download",
                      style: TextStyle(color: Colors.red, fontSize: 20.0)),
                  onPressed: () {
                    launchUrl(androidUrl); //到Google Play 官网下载
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      //iOS
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image.asset("images/ic_launcher_icon.png",
                  //     height: 35.0, width: 35.0),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
                      child: Text("检测到有新版本",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0)))
                ],
              ),
              content: Text(
                "New version v$_serviceVersionCode is available. " + "是否需要更新?",
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("later",
                      style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    var timeStart = DateTime.now().millisecondsSinceEpoch;
                    sharedAddAndUpdate("timeStart", int, timeStart); //保存当前的时间戳
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("download",
                      style: TextStyle(color: Colors.red, fontSize: 20.0)),
                  onPressed: () {
                    launchUrl(iosUrl); //到APP store 官网下载
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
