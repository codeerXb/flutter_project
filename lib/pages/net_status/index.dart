import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/model/online_device.dart';
import 'package:flutter_template/pages/system_settings/model/maintain_data.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_template/pages/net_status/coverage.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  String? name = '';
  // 请求获取设备名
  Future<String?> getDeviceName() async {
    var res = await Request().getEquipmentData();
    printInfo(info: '设备名字：${res.systemProductModel}');
    if (mounted && res.systemProductModel != null) {
      setState(() {
        name = res.systemProductModel;
      });
    }
    return res.systemProductModel;
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());
  final LoginController loginController = Get.put(LoginController());

  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接
  String _wifiStatus = '0';
  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';

  // 定义套餐类型
  final int _comboType = 0;
  // 定义套餐总量
  // 定义显示套餐状况
  final String _comboLabel = S.current.Notset;
  // 套餐周期
  List<String> comboCycleLabel = [
    S.current.day,
    S.current.month,
    S.current.year
  ];
  // 上行速率总数
  double _upRate = 0;
  //下行速率转换
  double upKb = 0;
  // 下行速率总数
  double _downRate = 0;
  // 下行速率转换
  double downKb = 0;
  // 实时在线设备数量
  int _onlineCount = 0;
  // 剩余流量百分比
  // double _progress = 0;

  // 已经使用的流量总数
  double _usedFlow = 0;
  // 已经使用的流量总数 整数部分
  int usedFlowInt = 0;
  // 已经使用的流量总数 小数部分
  String usedFlowDecimals = '0KB';

  // 下拉列表
  bool isShowList = false;
  String sn = '';
  String downUnit = 'Kbps';
  String upUnit = 'Kbps';

  String testUp = '0 Kbps';
  String testDown = '0 Kbps';
  String lantency = '0 ms';
  bool testLoading = false;

  Timer? timer;

  String getRate(rate) {
    double rateKb = rate * 8 / 1000;
    String unit = 'Kbps';
    if (rateKb >= 1000 * 1000) {
      // gbps
      rateKb = rateKb / 1000 / 1000;
      unit = 'Gbps';
    } else if (rateKb >= 1000 && rateKb <= 1000 * 1000) {
      // mbps
      rateKb = rateKb / 1000;
      unit = 'Mbps';
    } else {
      // kbps
      rateKb = rateKb;
      unit = 'Kbps';
    }
    return rateKb.toStringAsFixed(2) + unit;
  }

  String getPing(ping) {
    return '${ping}ms';
  }

  @override
  void initState() {
    super.initState();

    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      if (mounted) {
        setState(() {
          sn = res.toString();
          //状态为local 请求本地  状态为cloud  请求云端
          printInfo(info: 'state--${loginController.login.state}');
          if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
            getBasicInfo();
            getTROnlineCount(sn);
          }
          if (loginController.login.state == 'local') {
            // 获取流量
            getUsedFlow();
            // 获取设备列表并更新在线数量
            updateOnlineCount();
            // 获取网络连接状态和上下行速率并更新
            updateStatus();
          }

          App.get('/platform/cpeMqttSpeed/queryLatestSpeed', {'sn': sn})
              .then((res) {
            setState(() {
              testUp = getRate(res['data'].first['upload']);
              testDown = getRate(res['data'].first['download']);
              lantency = getPing(res['data'].first['ping']);
            });
          }).catchError((err) {
            printError(info: err.toString());
          });
        });
      }
    }));

    if (mounted) {
      getqueryingBoundDevices();
    }

    timer = Timer.periodic(const Duration(seconds: 2), (t) async {
      if (mounted) {
        printInfo(info: '定时获取的state--${loginController.login.state}');
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          getTROnlineCount(sn);
        }
        if (loginController.login.state == 'local') {
          // 获取设备类型
          getDeviceName();
          // 获取流量
          getUsedFlow();
          // 获取设备列表并更新在线数量
          updateOnlineCount();
          // 获取网络连接状态和上下行速率并更新
          updateStatus();
        }
      } else {
        timer?.cancel();
      }
    });

    // updateStatus();
    // timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
    //   if (mounted) updateStatus();
    // });

    // updateOnlineCount();
    // _comboType == 0 ? getUsedFlow() : updateOnlineTime();
    // timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
    //   if (mounted) {
    //     widget.comboType == 0 ? getUsedFlow() : updateOnlineTime();
    //     updateOnlineCount();
    //   }
    // });

    // 获取套餐总量
    sharedGetData('c_type', int).then((value) {
      printInfo(info: 'c_typevalue---$value');
      // if (value != null) {
      //   setState(() => _comboType = int.parse(value.toString()));
      // }
    });

    sharedGetData('c_contain', double).then((value) {
      printInfo(info: 'c_containvalue---$value');

      // if (value != null) {
      //   setState(() => _totalComboData = double.parse(value.toString()));
      // }
    });

    // Future.wait([
    //   sharedGetData('c_type', int),
    //   sharedGetData('c_contain', double),
    //   sharedGetData('c_cycle', int),
    // ]).then((results) {
    //   if (results[0] != null && results[1] != null && results[2] != null) {
    //     setState(() {
    //       _comboLabel = results[0] == 0
    //           ? '${results[1]}GB/${comboCycleLabel[results[2] as int]}'
    //           : '${results[1]}h/${comboCycleLabel[results[2] as int]}';
    //     });
    //   }
    // }).catchError((e) {
    //   printError(info: 'error:$e');
    // });
  }

//1连接
  var connectStatus = '1';

  /// 获取云端基础信息
  getBasicInfo() async {
    // Navigator.push(context, DialogRouter(LoadingDialog()));
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.ProductModel",
      "InternetGatewayDevice.WEB_GUI.Ethernet.Status.ConnectStatus",
    ];
    try {
      var res = await Request().getACSNode(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      if (mounted && jsonObj['data'] != null) {
        setState(() {
          connectStatus = jsonObj['data']['InternetGatewayDevice']['WEB_GUI']
              ['Ethernet']['Status']['ConnectStatus']['_value'];

          // 设定名字为产品类型
          name = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Overview"]
              ['VersionInfo']['ProductModel']['_value'];
        });
      }
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  ///  获取云端轮询信息
  getTROnlineCount(sn) async {
    // 已用流量
    // var flowTable = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
    //     ["Overview"]["ThroughputStatisticsList"];
    // double flowTableVal =
    //     double.parse(flowTable["1"]["ReceivedTotal"]["_value"]!) +
    //         double.parse(flowTable["1"]["SentTotal"]["_value"]!) +
    //         double.parse(flowTable["2"]["ReceivedTotal"]["_value"]!) +
    //         double.parse(flowTable["2"]["SentTotal"]["_value"]!) +
    //         double.parse(flowTable["3"]["ReceivedTotal"]["_value"]!) +
    //         double.parse(flowTable["3"]["SentTotal"]["_value"]!) +
    //         double.parse(flowTable["4"]["ReceivedTotal"]["_value"]!) +
    //         double.parse(flowTable["4"]["SentTotal"]["_value"]!);
    // _usedFlow = flowTableVal / 1048576;

    // /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
    // usedFlowInt = (_usedFlow >= 1024)
    //     ? (_usedFlow / 1024).truncate()
    //     : _usedFlow.truncate();

    // /// 获取小数部分，通过.分割，返回值为String类型
    // usedFlowDecimals = (_usedFlow >= 1024)
    //     ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
    //     : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';
    try {
      var updownRes = await App.get('/cpeMqtt/getCurrentInfo/$sn');

      if (updownRes['code'] == 200 && mounted) {
        setState(() {
          // 上下行速率
          _upRate = double.parse(updownRes['data']['ULRateCurrent'].toString());
          _downRate =
              double.parse(updownRes['data']['DLRateCurrent'].toString());

          downKb = (_downRate * 8) / 1000;
          if (downKb >= 1000 * 1000) {
            // gb/s
            downKb = double.parse((downKb / 1000 / 1000).toStringAsFixed(2));
            downUnit = 'Gbps';
          } else if (downKb >= 1000) {
            // mb/s
            downKb = double.parse((downKb / 1000).toStringAsFixed(2));
            downUnit = 'Mbps';
          }
          downKb = double.parse(downKb.toStringAsFixed(2));
          downUnit = 'Kbps';
          printInfo(info: 'time:${DateTime.now()}--down:$downKb$downUnit');

          upKb = (_upRate * 8) / 1000;
          if (upKb >= 1000 * 1000) {
            // gb/s
            upKb = double.parse((upKb / 1000 / 1000).toStringAsFixed(2));
            upUnit = 'Gbps';
          } else if (upKb >= 1000) {
            // mb/s
            upKb = double.parse((upKb / 1000).toStringAsFixed(2));
            upUnit = 'Mbps';
          }
          upKb = double.parse(upKb.toStringAsFixed(2));
          upUnit = 'Kbps';
          // 列表数量
          _onlineCount =
              int.parse(updownRes['data']['WifiDeviceNum'].toString()) +
                  int.parse(updownRes['data']['LanDeviceNum'].toString());
        });
      }
    } catch (err) {
      printError(info: err.toString());
      if (err is TimeoutException) {
        ToastUtils.error(S.current.timeout);
      }
    }
  }

  /// 获取设备列表并更新在线数量  本地
  void updateOnlineCount() async {
    try {
      Map<String, dynamic> queryOnlineDevice = {
        'method': 'tab_dump',
        'param': '["OnlineDeviceTable"]'
      };
      var res = await XHttp.get('/data.html', queryOnlineDevice);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(res) && mounted) {
        setState(() {
          _onlineCount = 0;
        });
        debugPrint('queryOnlineDevice得到数据不是json');
      }
      var onlineDevice =
          OnlineDevice.fromJson(jsonDecode(res)).onlineDeviceTable;
      if (onlineDevice != null && mounted) {
        setState(() {
          _onlineCount = onlineDevice.length;
        });
      }
      debugPrint('在线设备数量：${onlineDevice?.length}');
    } catch (e) {
      debugPrint("获取设备列表错误：${e.toString()}");
    }
  }

  /// 获取网络连接状态和上下行速率并更新  本地
  void updateStatus() async {
    Map<String, dynamic> netStatus = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectionStatus","systemDataRateDlCurrent","systemDataRateUlCurrent","wifiHaveOrNot","wifi5gHaveOrNot","wifiEnable","wifi5gEnable","lteRoam"]'
    };
    try {
      var response = await XHttp.get('/data.html', netStatus);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(response) && mounted) {
        setState(() {
          _wanStatus = '0';
          _wifiStatus = '0';
          _simStatus = '0';
          _upRate = 0;
          _downRate = 0;
        });
        debugPrint('netStatus得到数据不是json');
      }
      var resObj = NetConnecStatus.fromJson(json.decode(response));
      String wanStatus = resObj.ethernetConnectionStatus == '1' ? '1' : '0';
      String wifiStatus =
          (resObj.wifiHaveOrNot == '1' || resObj.wifi5gHaveOrNot == '1')
              ? '1'
              : '0';
      String simStatus = resObj.lteRoam == '1' ? '1' : '0';
      double upRate = resObj.systemDataRateUlCurrent != null
          ? double.parse(resObj.systemDataRateUlCurrent!)
          : 0;
      double downRate = resObj.systemDataRateDlCurrent != null
          ? double.parse(resObj.systemDataRateDlCurrent!)
          : 0;
      if (mounted) {
        setState(() {
          _wanStatus = wanStatus;
          _wifiStatus = wifiStatus;
          _simStatus = simStatus;
          _upRate = upRate;
          _downRate = downRate;
          downKb = (_downRate * 8) / 1000;
          if (downKb >= 1000 * 1000) {
            // gb/s
            downKb = double.parse((downKb / 1000 / 1000).toStringAsFixed(2));
            downUnit = 'Gbps';
          } else if (downKb >= 1000) {
            // mb/s
            downKb = double.parse((downKb / 1000).toStringAsFixed(2));
            downUnit = 'Mbps';
          }
          downKb = double.parse(downKb.toStringAsFixed(2));
          downUnit = 'Kbps';

          upKb = (_upRate * 8) / 1000;
          if (upKb >= 1000 * 1000) {
            // gb/s
            upKb = double.parse((upKb / 1000 / 1000).toStringAsFixed(2));
            upUnit = 'Gbps';
          } else if (upKb >= 1000) {
            // mb/s
            upKb = double.parse((upKb / 1000).toStringAsFixed(2));
            upUnit = 'Mbps';
          }
          upKb = double.parse(upKb.toStringAsFixed(2));
          upUnit = 'Kbps';
        });
      }
      debugPrint('wanStatus=$wanStatus,wifi=$wifiStatus,sim=$simStatus');
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  /// 请求获取已用流量  本地
  Future<double> getUsedFlow() async {
    Map<String, dynamic> flowStatistics = {
      'method': 'tab_dump',
      'param': '["FlowTable"]',
    };
    try {
      var obj = await XHttp.get('/data.html', flowStatistics);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(obj) && mounted) {
        setState(() {
          _usedFlow = 0;
          // _progress = 0;
        });
        debugPrint('flowStatistics得到数据不是json');
      }
      var jsonObj = json.decode(obj);
      var flowTable = FlowStatistics.fromJson(jsonObj).flowTable;
      if (flowTable != null && mounted) {
        // 得到流量卡的总通过流量
        double usedFlowBytes = double.parse(flowTable[0].recvBytes!) +
            double.parse(flowTable[0].sendBytes!) +
            double.parse(flowTable[1].recvBytes!) +
            double.parse(flowTable[1].sendBytes!) +
            double.parse(flowTable[2].recvBytes!) +
            double.parse(flowTable[2].sendBytes!) +
            double.parse(flowTable[3].recvBytes!) +
            double.parse(flowTable[3].sendBytes!);
        setState(() {
          _usedFlow = usedFlowBytes / 1048576;

          /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
          usedFlowInt = (_usedFlow >= 1024)
              ? (_usedFlow / 1024).truncate()
              : _usedFlow.truncate();

          /// 获取小数部分，通过.分割，返回值为String类型
          usedFlowDecimals = (_usedFlow >= 1024)
              ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
              : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';
        });
      }
      return _usedFlow;
    } catch (e) {
      debugPrint('获取流量信息错误：${e.toString()}');
    }
    return _usedFlow;
  }

  // body loading
  bool loading = false;
  // home page loading
  bool loadingDevice = false;
  //设备下拉
  List optionsList = [];
  String currentDevice = '';
  List deviceList = [];

  // 重启
  MaintainData maintainVal = MaintainData();

  // 恢复
  MaintainData factoryReset = MaintainData();
  //  查询绑定设备 App
  void getqueryingBoundDevices() {
    if (mounted) {
      setState(() {
        loadingDevice = true;
      });
      App.get('/platform/appCustomer/queryCustomerCpe').then((res) {
        if (res == null || res.toString().isEmpty) {
          throw Exception('Response is empty.');
        }
        var d = json.decode(json.encode(res));
        printInfo(info: '查询的绑定设备$d');
        if (d['code'] != 200) {
          // 9999：用户令牌不能为空
          // 9998：平台登录标识不能为空
          // 9996：用户令牌过期或非法
          // 9997：平台登录标识非法
          if (d['code'] == 9999 ||
              d['code'] == 9998 ||
              d['code'] == 9997 ||
              d['code'] == 9996) {
            ToastUtils.error(S.of(context).tokenExpired);
            sharedDeleteData('user_token');
            Get.offAllNamed('/user_login');
          } else {
            ToastUtils.error(S.of(context).failed);
          }
          return;
        } else {
          setState(() {
            // [{id: 1, deviceSn: RS621A00211700113, type: SRS621-a},
            //{id: 2, deviceSn: 1245, type: SRS821-k}]
            deviceList = d['data'];
            var options = [];
            d['data'].forEach((item) {
              options.add(item['type'].toString());
            });
            optionsList = options;
          });
          // 读取当前
          sharedGetData('deviceSn', String).then(((res) {
            if (res != '') {
              setState(() {
                d['data'].forEach((item) {
                  if (item['deviceSn'] == res) {
                    currentDevice = item['type'];
                  }
                });
                if (currentDevice == '') {
                  Get.offNamed('/get_equipment');
                  sharedDeleteData('deviceSn');
                  ToastUtils.error('Current device unbind');
                }
              });
            } else {
              Get.offNamed('/get_equipment');
              sharedDeleteData('deviceSn');
              ToastUtils.error('Current device unbind');
            }
          }));
        }
      }).catchError((onError) {
        debugPrint(onError.toString());
      }).whenComplete(() {
        setState(() {
          loadingDevice = false;
        });
      });
    }
  }

  void loginout() {
    // 出了usertoken不清除其他都可以清除
    sharedDeleteData('user_phone');
    sharedDeleteData('deviceSn');
    Get.offAllNamed("/get_equipment");
  }

  // 重启 云端
  void getReBootData() {
    App.post('/platform/tr069/rebootDevice?deviceId=$sn').then((res) {
      var d = json.decode(res.toString());
      debugPrint('响应------>$d');
      if (d['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((err) {
      ToastUtils.error(S.current.contimeout);
    });
  }

  // 重启
  void getmaintaData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemReboot":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          maintainVal = MaintainData.fromJson(d);
          if (maintainVal.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 恢复出厂 云端
  void getfactoryResetData() {
    App.post('/platform/tr069/factoryReset?deviceId=$sn').then((res) {
      var d = json.decode(res.toString());
      debugPrint('响应------>$d');
      if (d['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((err) {
      ToastUtils.error(S.current.contimeout);
    });
  }

  // 恢复出厂
  void getfactoryReset() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemFactoryReset":"1","systemRebootFlag":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          factoryReset = MaintainData.fromJson(d);
          if (factoryReset.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // test speed
  void testSpeed() async {
    setState(() {
      testLoading = true;
    });
    try {
      var app = await App.post('/platform/cpeMqttSpeed/sendSpeedTest',
          data: {'sn': sn});
      debugPrint('我的createTime${app.toString()}');
      // 5002
      debugPrint('我的createTime${jsonDecode(app)['code']}');
      if (jsonDecode(app)['code'] == 5002) {
        setState(() {
          testLoading = false;
        });
      }
      var res =
          await App.get('/platform/cpeMqttSpeed/queryLatestSpeed', {'sn': sn});
      final createTime = res['data'].first['createTime'];
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        var speed = await App.get(
            '/platform/cpeMqttSpeed/queryLatestSpeed', {'sn': sn});
        debugPrint(
            '我的createTime$createTime,${speed['data'].first['createTime']},${speed['data'].length.toString()}');
        if (speed['data'].first['createTime'] != createTime) {
          setState(() {
            testUp = getRate(res['data'].first['upload']);
            testDown = getRate(res['data'].first['download']);
            lantency = getPing(res['data'].first['ping']);
          });
          timer.cancel();
          setState(() {
            testLoading = false;
          });
        }
      });
    } catch (e) {
      printInfo(info: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingDevice) {
      return const Center(
          child: SizedBox(width: 100, height: 100, child: WaterLoading()));
    } else {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                'assets/images/picture_home_bg.png',
              ),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            // 不自动添加返回键
            automaticallyImplyLeading: false,
            title: InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              // 下拉icon
              child: SizedBox(
                width: 1.sw,
                child: DropdownButton(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                  ),
                  dropdownColor: Colors.black.withAlpha(180), // 设置下拉框的背景颜色
                  underline: Container(), //去除下划线
                  value: currentDevice,
                  // icon: Icon(
                  //   FontAwesomeIcons.chevronDown,
                  //   size: 30.w,
                  //   color: Colors.white,
                  // ),
                  iconEnabledColor: Colors.white,
                  items: optionsList.map((option) {
                    // bool isSelected = option == currentDevice;
                    return DropdownMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          Text(option),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      loading = true;
                      currentDevice = value.toString();
                      String? deviceSn;
                      for (var item in deviceList) {
                        if (item['type'] == value.toString()) {
                          deviceSn = item['deviceSn'];
                        }
                      }
                      // 为了更新新的设备
                      Get.offNamed("/get_equipment");
                      Get.offNamed("/home");
                      loginController.setUserEquipment(
                          'deviceSn', deviceSn.toString());
                      sharedAddAndUpdate(
                          "deviceSn", String, deviceSn.toString());
                      loginController.setState('cloud');
                      ToastUtils.toast('Save success');
                      loading = false;
                    });
                  },
                  onTap: (() {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isShowList = !isShowList;
                      });
                    });
                  }),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: loading
              ? const Center(
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: WaterLoading(
                      color: Color.fromARGB(255, 65, 167, 251),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => closeKeyboard(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
                    height: 1000,
                    child: ListView(
                      children: [
                        // const Center(
                        //     child: Text(
                        //   'Mapping out your Wi-Fi Coverage',
                        //   style: TextStyle(fontWeight: FontWeight.w600),
                        // )),
                        // 热力图
                        // const TestEdit(),

                        // 网络环境
                        WhiteCard(
                            height: 210,
                            boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Text(
                                    connectStatus == '1'
                                        ? S.current.Connected
                                        : S.current.ununited,
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        color: const Color(0xff051220)),
                                  ),
                                ),
                                // Column(
                                //   children: [
                                // Text(
                                //   S.of(context).good,
                                //   style: TextStyle(
                                //       fontSize: 30.sp,
                                //       color: const Color.fromRGBO(
                                //           95, 141, 255, 1)),
                                // ),
                                // Text(
                                //   S.of(context).Environment,
                                //   style: TextStyle(
                                //       fontSize: 30.sp,
                                //       color: const Color.fromRGBO(
                                //           95, 141, 255, 1)),
                                // ),
                                //   ],
                                // ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(80.w, 80.w)),
                                        shape: MaterialStateProperty.all(
                                            const CircleBorder()),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Color.fromRGBO(
                                                    235, 235, 235, 1)),
                                      ),
                                      onPressed: () {
                                        // 测速
                                        testSpeed();
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            testLoading
                                                ? const CircularProgressIndicator(
                                                    color: Color.fromRGBO(
                                                        95, 141, 255, 1),
                                                  )
                                                : Icon(
                                                    Icons.network_check,
                                                    color: const Color.fromRGBO(
                                                        95, 141, 255, 1),
                                                    size: 60.sp,
                                                  )
                                          ]),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      S.current.netSpeed,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 50, 121),
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                const Expanded(
                                  child: Icon(
                                    Icons.thumb_up,
                                    size: 32,
                                    color: Color.fromRGBO(95, 141, 255, 1),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tip: Last Speed test',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize:  10),
                                    ),
                                    const SizedBox(height: 3,),
                                    Text(
                                      'Up⬆ $testUp',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 3,),
                                    Text(
                                      'Down⬇ $testDown',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 3,),
                                    Text(
                                      'Lantency $lantency',
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        //流量套餐
                        // WhiteCard(
                        //     boxCotainer: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Expanded(
                        //       child: Column(
                        //         children: [
                        //           Text(
                        //             '$usedFlowInt.$usedFlowDecimals',
                        //             style: TextStyle(
                        //                 fontSize: 30.sp,
                        //                 color: const Color(0xff051220)),
                        //           ),
                        //           Text(
                        //             S.of(context).used,
                        //             style: TextStyle(
                        //               fontSize: 28.sp,
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     ElevatedButton(
                        //       style: ButtonStyle(
                        //         shape: MaterialStateProperty.all(
                        //             const CircleBorder()),
                        //         minimumSize: MaterialStateProperty.all<Size>(
                        //             Size(100.w, 100.w)),
                        //       ),
                        //       onPressed: () {
                        //         Get.toNamed('/net_server_settings')
                        //             ?.then((value) {
                        //           setState(() {
                        //             _comboLabel = value['type'] == 0
                        //                 ? '${value['contain']}GB/${comboCycleLabel[value['cycle']]}'
                        //                 : '${value['contain']}h/${comboCycleLabel[value['cycle']]}';
                        //             _comboType = value['type'];
                        //           });
                        //         });
                        //       },
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             S.of(context).traffic,
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(fontSize: 20.sp),
                        //           ),
                        //           Text(
                        //             S.of(context).sets,
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(fontSize: 20.sp),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Column(
                        //         children: [
                        //           Text(
                        //             '5 GB / ${S.current.month}',
                        //             style: TextStyle(
                        //                 fontSize: 30.sp,
                        //                 color: const Color(0xff051220)),
                        //           ),
                        //           Text(
                        //             S.of(context).trafficPackage,
                        //             style: TextStyle(
                        //               fontSize: 24.sp,
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // )),
                        //上传速率
                        WhiteCard(
                            height: 218,
                            boxCotainer: Column(
                              children: [
                                const Text(
                                  'Tip: Current traffic passed',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '$upKb$upUnit',
                                            style: TextStyle(
                                                fontSize: 30.sp,
                                                color: const Color(0xff051220)),
                                          ),
                                          Text(
                                            S.current.up,
                                            style: TextStyle(
                                              fontSize: 28.sp,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const CircleBorder()),
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(100.w, 100.w)),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Color.fromRGBO(
                                                        235, 235, 235, 1)),
                                          ),
                                          onPressed: () {
                                            Get.toNamed('/wlan_set');
                                          },
                                          child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                    image: AssetImage(
                                                        'assets/images/wlan.png')),
                                              ]),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          S.current.wlanSet,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 50, 121),
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    // 下载速率
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '$downKb$downUnit',
                                            style: TextStyle(
                                                fontSize: 30.sp,
                                                color: const Color(0xff051220)),
                                          ),
                                          Text(
                                            S.current.down,
                                            style: TextStyle(
                                              fontSize: 28.sp,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        //2*3网格
                        Container(
                          margin: EdgeInsets.only(
                              left: 30.w, right: 30.0.w, top: 20.w),
                          height: 480.w,
                          child: GridView(
                            physics:
                                const NeverScrollableScrollPhysics(), //禁止滚动
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, //一行的Widget数量
                              childAspectRatio: 2, //宽高比为1
                              crossAxisSpacing: 16, //横轴方向子元素的间距
                            ),
                            children: <Widget>[
                              // 接入设备
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/connected_device');
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.devices_other_rounded,
                                        color: const Color.fromRGBO(
                                            95, 141, 255, 1),
                                        size: 60.sp),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(S.current.device),
                                          Text(
                                            '$_onlineCount ${S.current.line}',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 25.sp),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                              ),
                              //儿童上网
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/parent');
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.child_care,
                                        color: const Color.fromRGBO(
                                            95, 141, 255, 1),
                                        size: 60.sp),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 180.w,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          S.current.parent,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              //摄像头
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.toNamed('/vidicon');
                              //   },
                              //   child: GardCard(
                              //       boxCotainer: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       FaIcon(
                              //         FontAwesomeIcons.video,
                              //         color:
                              //             const Color.fromRGBO(95, 141, 255, 1),
                              //         size: 80.sp,
                              //       ),
                              //       ConstrainedBox(
                              //         constraints: BoxConstraints(
                              //           maxWidth: 180.w,
                              //         ),
                              //         child: FittedBox(
                              //           child: Text(
                              //             S.current.monitor,
                              //             textAlign: TextAlign.right,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   )),
                              // ),

                              // 访客网路
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/visitor_net");
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 80.w,
                                        height: 80.w,
                                        image: const AssetImage(
                                            'assets/images/visitor_net.png')),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 180.w,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          S.current.visitorNet,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              // wifi覆盖图
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.toNamed("/test_edit");
                              //   },
                              //   child: GardCard(
                              //       boxCotainer: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Image(
                              //           width: 55.w,
                              //           height: 55.w,
                              //           image: const AssetImage(
                              //               'assets/images/signal_cover.png')),
                              //       ConstrainedBox(
                              //         constraints: BoxConstraints(
                              //           maxWidth: 180.w,
                              //         ),
                              //         child: FittedBox(
                              //           child: Text(
                              //             S.current.wifiMapping,
                              //             textAlign: TextAlign.right,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   )),
                              // ),
                              // Device Info
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/common_problem");
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 55.w,
                                        height: 55.w,
                                        image: const AssetImage(
                                            'assets/images/equ_info.png')),
                                    Expanded(
                                      child: Text(
                                        S.current.deviceInfo,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13,color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              // DNS Setting
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/dns_settings");
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 80.w,
                                        height: 80.w,
                                        image: const AssetImage(
                                            'assets/images/DNS.png')),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 180.w,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          S.current.dnsSettings,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              // LAN Setting
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/lan_settings");
                                },
                                child: GardCard(
                                    boxCotainer: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 80.w,
                                        height: 80.w,
                                        image: const AssetImage(
                                            'assets/images/lan.png')),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 180.w,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          S.current.lanSettings,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),

                              //网课加速
                              // GardCard(
                              //   boxCotainer: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Icon(Icons.book,
                              //           color: const Color.fromRGBO(
                              //               95, 141, 255, 1),
                              //           size: 80.sp),
                              //       ConstrainedBox(
                              //         constraints: BoxConstraints(
                              //           maxWidth: 180.w,
                              //         ),
                              //         child: FittedBox(
                              //           child: Text(
                              //             S.current.online,
                              //             textAlign: TextAlign.right,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              //游戏加速
                              // GardCard(
                              //     boxCotainer: Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Icon(
                              //       Icons.speed,
                              //       color:
                              //           const Color.fromRGBO(95, 141, 255, 1),
                              //       size: 80.sp,
                              //     ),
                              //     ConstrainedBox(
                              //       constraints: BoxConstraints(
                              //         maxWidth: 180.w,
                              //       ),
                              //       child: FittedBox(
                              //         child: Text(
                              //           S.current.game,
                              //           textAlign: TextAlign.right,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )),
                            ],
                          ),
                        ),
                        //  设备操作
                        WhiteCard(
                            height: 258,
                            boxCotainer: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20.w),
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Device Control',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                            Size>(
                                                        Size(100.w, 100.w)),
                                                shape:
                                                    MaterialStateProperty.all(
                                                        const CircleBorder()),
                                                backgroundColor:
                                                    const MaterialStatePropertyAll(
                                                        Color.fromRGBO(
                                                            16, 80, 255, 1)),
                                              ),
                                              onPressed: () {
                                                // 显示弹窗
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          title: Text(
                                                              S.current.hint),
                                                          content: Text(S
                                                              .of(context)
                                                              .isGoOn),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(S
                                                                  .current
                                                                  .cancel),
                                                              onPressed: () {
                                                                //取消
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancle');
                                                              },
                                                            ),
                                                            TextButton(
                                                                child: Text(S
                                                                    .current
                                                                    .confirm),
                                                                onPressed: () {
                                                                  //确定
                                                                  Navigator.pop(
                                                                      context,
                                                                      "Ok");
                                                                  Navigator.push(
                                                                      context,
                                                                      DialogRouter(
                                                                          LoadingDialog()));
                                                                  if (mounted) {
                                                                    if (loginController.login.state ==
                                                                            'cloud' &&
                                                                        sn.isNotEmpty) {
                                                                      getReBootData();
                                                                    }
                                                                    if (loginController
                                                                            .login
                                                                            .state ==
                                                                        'local') {
                                                                      getmaintaData();
                                                                    }
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                })
                                                          ]);
                                                    });
                                              },
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .arrowsRotate,
                                                      size: 30.w,
                                                      color: Colors.white,
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        const Text('Reboot')
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                            Size>(
                                                        Size(100.w, 100.w)),
                                                shape:
                                                    MaterialStateProperty.all(
                                                        const CircleBorder()),
                                                backgroundColor:
                                                    const MaterialStatePropertyAll(
                                                        Color.fromRGBO(
                                                            16, 80, 255, 1)),
                                              ),
                                              onPressed: () {
                                                // 恢复出厂设置
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          title: Text(
                                                              S.current.hint),
                                                          content: Text(S
                                                              .of(context)
                                                              .isGoOn),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(S
                                                                  .current
                                                                  .cancel),
                                                              onPressed: () {
                                                                //取消
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancle');
                                                              },
                                                            ),
                                                            TextButton(
                                                                child: Text(S
                                                                    .current
                                                                    .confirm),
                                                                onPressed: () {
                                                                  //确定
                                                                  Navigator.pop(
                                                                      context,
                                                                      "Ok");
                                                                  Navigator.push(
                                                                      context,
                                                                      DialogRouter(
                                                                          LoadingDialog()));
                                                                  if (mounted) {
                                                                    if (loginController.login.state ==
                                                                            'cloud' &&
                                                                        sn.isNotEmpty) {
                                                                      getfactoryResetData();
                                                                    }
                                                                    if (loginController
                                                                            .login
                                                                            .state ==
                                                                        'local') {
                                                                      getfactoryReset();
                                                                    }
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                })
                                                          ]);
                                                    });
                                              },
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.replyAll,
                                                      size: 30.w,
                                                      color: Colors.white,
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        const Text('Reset')
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),

                        //查看更多
                        TextButton(
                          style: const ButtonStyle(
                            textStyle: MaterialStatePropertyAll(
                              TextStyle(
                                color: Color.fromRGBO(95, 141, 255, 1),
                              ),
                            ),
                          ),
                          onPressed: () {
                            toolbarController.setPageIndex(2);
                          },
                          child: Text(S.current.more),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('状态页面销毁');
    timer?.cancel();
    timer = null;
  }
}

//card
class WhiteCard extends StatelessWidget {
  final Widget boxCotainer;
  final double height;
  const WhiteCard({super.key, required this.boxCotainer, this.height = 150});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.w,
      padding: EdgeInsets.all(28.0.w),
      margin: EdgeInsets.only(top: 20.w, left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: boxCotainer,
    );
  }
}

//card
class GardCard extends StatelessWidget {
  final Widget boxCotainer;
  const GardCard({super.key, required this.boxCotainer});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.w,
      padding: EdgeInsets.all(28.0.w),
      margin: EdgeInsets.only(bottom: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: boxCotainer,
    );
  }
}
