import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/model/online_device.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
    setState(() {
      name = res.systemProductModel;
    });
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
  int _comboType = 0;
  // 定义套餐总量
  // 定义显示套餐状况
  String _comboLabel = S.current.Notset;
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
  List<Map<String, dynamic>> get serviceList => [
        {
          'label': name,
          'sn': '12123213',
        },
        {
          'label': 'test',
          'sn': '12123213',
        }
      ];
  String sn = '';
  String dowUnit = 'Kbps';
  String upUnit = 'Kbps';

  Timer? timer;
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (t) async {
      printInfo(info: 'state--${loginController.login.state}');
      if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
        if (mounted) {
          getTROnlineCount();
        }
      }
      if (loginController.login.state == 'local') {
        if (mounted) {
          // 获取设备类型
          getDeviceName();
          // 获取流量
          getUsedFlow();
          // 获取设备列表并更新在线数量
          updateOnlineCount();
          // 获取网络连接状态和上下行速率并更新
          updateStatus();
        }
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

    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          if (mounted) {
            getTROnlineCount();
          }
        }
        if (loginController.login.state == 'local') {
          if (mounted) {
            // 获取流量
            getUsedFlow();
            // 获取设备列表并更新在线数量
            updateOnlineCount();
            // 获取网络连接状态和上下行速率并更新
            updateStatus();
          }
        }
      });
    }));
  }

  ///  获取  云端
  getTROnlineCount() async {
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.ProductModel",
      "InternetGatewayDevice.WEB_GUI.Overview.DeviceList",
      "InternetGatewayDevice.WEB_GUI.Overview.ThroughputStatisticsList",
      "InternetGatewayDevice.WEB_GUI.Overview.WANStatus.DLRateCurrent",
      "InternetGatewayDevice.WEB_GUI.Overview.WANStatus.ULRateCurrent"
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      if (!mounted) return;
      setState(() {
        // 列表数量
        Map<String, dynamic> flowTableName = jsonObj["data"]
            ["InternetGatewayDevice"]["WEB_GUI"]["Overview"]["DeviceList"];
        _onlineCount = flowTableName.keys
            .toList()
            .where((element) {
              var pattern = RegExp(r'[0-9]+');
              var isMatch = pattern.hasMatch(element);
              return isMatch;
            })
            .toList()
            .length;
        // 设定名字为产品类型
        name = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Overview"]
            ['VersionInfo']['ProductModel']['_value'];
        // 已用流量
        var flowTable = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["ThroughputStatisticsList"];
        double flowTableVal =
            double.parse(flowTable["1"]["ReceivedTotal"]["_value"]!) +
                double.parse(flowTable["1"]["SentTotal"]["_value"]!) +
                double.parse(flowTable["2"]["ReceivedTotal"]["_value"]!) +
                double.parse(flowTable["2"]["SentTotal"]["_value"]!) +
                double.parse(flowTable["3"]["ReceivedTotal"]["_value"]!) +
                double.parse(flowTable["3"]["SentTotal"]["_value"]!) +
                double.parse(flowTable["4"]["ReceivedTotal"]["_value"]!) +
                double.parse(flowTable["4"]["SentTotal"]["_value"]!);
        _usedFlow = flowTableVal / 1048576;

        /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
        usedFlowInt = (_usedFlow >= 1024)
            ? (_usedFlow / 1024).truncate()
            : _usedFlow.truncate();

        /// 获取小数部分，通过.分割，返回值为String类型
        usedFlowDecimals = (_usedFlow >= 1024)
            ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
            : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';

        // 上下行速率
        var flow = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["WANStatus"];
        _upRate = double.parse(flow["ULRateCurrent"]["_value"]);
        _downRate = double.parse(flow["DLRateCurrent"]["_value"]);

        downKb = (_downRate * 8) / 1000;
        if (downKb >= 1000 * 1000) {
          // gb/s
          downKb = double.parse((downKb / 1000 / 1000).toStringAsFixed(2));
          dowUnit = 'Gbps';
        } else if (downKb >= 1000) {
          // mb/s
          downKb = double.parse((downKb / 1000).toStringAsFixed(2));
          dowUnit = 'Mbps';
        }
        downKb = double.parse(downKb.toStringAsFixed(2));
        dowUnit = 'Kbps';

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
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
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
            dowUnit = 'Gbps';
          } else if (downKb >= 1000) {
            // mb/s
            downKb = double.parse((downKb / 1000).toStringAsFixed(2));
            dowUnit = 'Mbps';
          }
          downKb = double.parse(downKb.toStringAsFixed(2));
          dowUnit = 'Kbps';

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

// 下拉列表
  Widget buildGrid() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in serviceList) {
      tiles.add(Container(
        padding: EdgeInsets.only(left: 20.w, top: 20.w, bottom: 20.w),
        child: InkWell(
          onTap: () {},
          child: Row(children: <Widget>[
            if (item['label'] == name.toString())
              Padding(
                padding: EdgeInsets.only(right: 16.sp),
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 30.w,
                  color: Colors.white,
                ),
              ),
            Text(
              item['label'],
              style: TextStyle(color: Colors.white, fontSize: 30.sp),
            ),
          ]),
        ),
      ));
    }
    content = Container(
      color: const Color.fromARGB(153, 31, 31, 31),
      width: 1.sw,
      child: Column(
          children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
          //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
          ),
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(
              'assets/images/picture_home.png',
            ),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: InkWell(
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            onTap: () {
              setState(() {
                isShowList = !isShowList;
              });
            },
            //下拉icon
            child: SizedBox(
              width: 1.sw,
              child: Row(
                children: [
                  Text(name.toString()),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 30.w,
                  )
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 1000,
            child: Stack(
              children: [
                // 头部下拉widget
                Container(
                  width: 1.sw,
                  height: 200.h,
                  color: Colors.transparent,
                ),
                // if (isShowList) Positioned(top: 10.w, child: buildGrid()),
                Padding(
                  padding: EdgeInsets.only(top: 20.w),
                  child: ListView(
                    children: [
                      // //热力图
                      Container(
                        height: 600.w,
                        margin: EdgeInsets.only(bottom: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        child: Image.asset(
                          'assets/images/state.png',
                        ),
                      ),
                      //网络环境
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            S.current.Connected,
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: const Color(0xff051220)),
                          ),
                          Column(
                            children: [
                              Text(
                                S.of(context).good,
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.blue),
                              ),
                              Text(
                                S.of(context).Environment,
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.blue),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.rocket,
                                    size: 32,
                                  )
                                ]),
                          )
                        ],
                      )),
                      //流量套餐
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '$usedFlowInt.$usedFlowDecimals',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: const Color(0xff051220)),
                                ),
                                Text(
                                  S.of(context).used,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(100.w, 100.w)),
                            ),
                            onPressed: () {
                              Get.toNamed('/net_server_settings')
                                  ?.then((value) {
                                setState(() {
                                  _comboLabel = value['type'] == 0
                                      ? '${value['contain']}GB/${comboCycleLabel[value['cycle']]}'
                                      : '${value['contain']}h/${comboCycleLabel[value['cycle']]}';
                                  _comboType = value['type'];
                                });
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).traffic,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                Text(
                                  S.of(context).sets,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '5 GB / ${S.current.month}',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: const Color(0xff051220)),
                                ),
                                Text(
                                  S.of(context).trafficPackage,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      //上传速率
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(100.w, 100.w)),
                            ),
                            onPressed: () {
                              Get.toNamed('/wlan_set');
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.wifi_outlined,
                                    size: 32,
                                  )
                                ]),
                          ),
                          // 下载速率
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '$downKb$dowUnit',
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
                      )),
                      //2*3网格
                      SizedBox(
                        height: 480.w,
                        child: GridView(
                          physics: const NeverScrollableScrollPhysics(), //禁止滚动
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //一行的Widget数量
                            childAspectRatio: 2, //宽高比为1
                            crossAxisSpacing: 16, //横轴方向子元素的间距
                          ),
                          children: <Widget>[
                            //接入设备
                            GardCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.devices_other_rounded,
                                    color: Colors.blue[500], size: 80.sp),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.current.device),
                                    Text(
                                      '$_onlineCount ${S.current.line}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 25.sp),
                                    ),
                                  ],
                                )
                              ],
                            )),
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
                                      color: Colors.blue[500], size: 80.sp),
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
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/vidicon');
                              },
                              child: GardCard(
                                  boxCotainer: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.video,
                                    color: Colors.blue[500],
                                    size: 80.sp,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 180.w,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        S.current.monitor,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            //网络测速
                            GardCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.network_check,
                                  color: Colors.blue[500],
                                  size: 80.sp,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 180.w,
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      S.current.netSpeed,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            //网课加速
                            GardCard(
                              boxCotainer: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.book,
                                      color: Colors.blue[500], size: 80.sp),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 180.w,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        S.current.online,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //游戏加速
                            GardCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.speed,
                                  color: Colors.blue[500],
                                  size: 80.sp,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 180.w,
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      S.current.game,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      //查看更多
                      TextButton(
                          onPressed: () {
                            toolbarController.setPageIndex(2);
                          },
                          child: Text(S.current.more))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
  const WhiteCard({super.key, required this.boxCotainer});
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
