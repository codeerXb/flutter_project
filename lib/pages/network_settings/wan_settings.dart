import 'dart:async';
import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
// import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/otp_input.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/network_settings/model/wan_data.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  Timer? timer;
  netDatas netdata = netDatas(
      //连接模式
      ethernetConnectMode: '',
      //仅以太网
      ethernetConnectOnly: '',
      //MTU
      ethernetMtu: '',
      //检测服务器
      ethernetDetectServer: '');
  //连接模式
  String showVal = S.current.DynamicIP;
  int val = 0;
  //优先级
  String priorityVal = S.current.Ethernet;
  int priorityIndex = 0;
  bool isCheck = true;
  String systemRouter = "";
  final TextEditingController mtu = TextEditingController();
  final TextEditingController server = TextEditingController();
  dynamic ipVal = '';
  final TextEditingController ipVal1 = TextEditingController();
  final TextEditingController ipVal2 = TextEditingController();
  final TextEditingController ipVal3 = TextEditingController();
  final TextEditingController ipVal4 = TextEditingController();
  dynamic maskVal = '';
  final TextEditingController maskVal1 = TextEditingController();
  final TextEditingController maskVal2 = TextEditingController();
  final TextEditingController maskVal3 = TextEditingController();
  final TextEditingController maskVal4 = TextEditingController();
  dynamic gatewayVal = '';
  final TextEditingController gatewayVal1 = TextEditingController();
  final TextEditingController gatewayVal2 = TextEditingController();
  final TextEditingController gatewayVal3 = TextEditingController();
  final TextEditingController gatewayVal4 = TextEditingController();
  dynamic primaryDNS = '';
  final TextEditingController primaryDNS1 = TextEditingController();
  final TextEditingController primaryDNS2 = TextEditingController();
  final TextEditingController primaryDNS3 = TextEditingController();
  final TextEditingController primaryDNS4 = TextEditingController();
  dynamic secondaryDNS = '';
  final TextEditingController secondaryDNS1 = TextEditingController();
  final TextEditingController secondaryDNS2 = TextEditingController();
  final TextEditingController secondaryDNS3 = TextEditingController();
  final TextEditingController secondaryDNS4 = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    sharedGetData('systemRouterOnly', String).then(((res) {
      printInfo(info: 'systemRouter$res');
      systemRouter = res.toString();
      debugPrint("当前拿到的值是:$systemRouter");
    }));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  String sn = '';
  String vn = '';
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //保存
  void handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': params,
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        printError(info: e.toString());
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  bool loading = false;
  final LoginController loginController = Get.put(LoginController());

  // 只读取本地数据
  Future getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemVersionSn","systemProductModel","ethernetConnectMode","ethernetConnectOnly","ethernetConnectPriority","ethernetIp","ethernetMask","ethernetDefaultGateway","ethernetPrimaryDns","ethernetSecondaryDns","ethernetMtu","ethernetDetectServer","systemCurrentPlatform","wifiEzmeshEnable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());

      // 验证成功更新数据
      setState(() {
        netdata = netDatas.fromJson(d);
        //连接模式
        switch (netdata.ethernetConnectMode.toString()) {
          case 'dhcp':
            showVal = S.current.DynamicIP;
            break;
          case 'static':
            showVal = S.current.staticIP;
            break;
          case 'lanonly':
            showVal = S.current.LANOnly;
            break;
        }
        val = ['dhcp', 'static', 'lanonly']
            .indexOf(netdata.ethernetConnectMode.toString());
        //仅以太网
        isCheck = netdata.ethernetConnectOnly.toString() == '1' ? true : false;
        //优先级 == '1' 4g
        priorityVal = netdata.ethernetConnectPriority.toString() == '1'
            ? '4G/5G'
            : S.current.Ethernet;
        priorityIndex = [S.current.Ethernet, '4G/5G'].indexOf(priorityVal);
        //mtu
        mtu.text = netdata.ethernetMtu.toString();
        //检测服务器
        server.text = netdata.ethernetDetectServer.toString();
        // IP地址
        ipVal = netdata.ethernetIp.toString();
        if (ipVal != "" && ipVal != null) {
          ipVal1.text = ipVal.split('.')[0];
          ipVal2.text = ipVal.split('.')[1];
          ipVal3.text = ipVal.split('.')[2];
          ipVal4.text = ipVal.split('.')[3];
        } else {
          ipVal1.text = ipVal2.text = ipVal3.text = ipVal4.text = "";
        }
        // 子网掩码
        maskVal = netdata.ethernetMask.toString();
        if (maskVal != "" && maskVal != null) {
          maskVal1.text = maskVal.split('.')[0];
          maskVal2.text = maskVal.split('.')[1];
          maskVal3.text = maskVal.split('.')[2];
          maskVal4.text = maskVal.split('.')[3];
        } else {
          maskVal1.text = maskVal2.text = maskVal3.text = maskVal4.text = "";
        }
        // 默认网关
        gatewayVal = netdata.ethernetDefaultGateway.toString();
        if (gatewayVal != "" && gatewayVal != null) {
          gatewayVal1.text = gatewayVal.split('.')[0];
          gatewayVal2.text = gatewayVal.split('.')[1];
          gatewayVal3.text = gatewayVal.split('.')[2];
          gatewayVal4.text = gatewayVal.split('.')[3];
        } else {
          gatewayVal1.text =
              gatewayVal2.text = gatewayVal3.text = gatewayVal4.text = "";
        }
        // 主DNS
        primaryDNS = netdata.ethernetPrimaryDns.toString();
        if (primaryDNS != "" && primaryDNS != null) {
          primaryDNS1.text = primaryDNS.split('.')[0];
          primaryDNS2.text = primaryDNS.split('.')[1];
          primaryDNS3.text = primaryDNS.split('.')[2];
          primaryDNS4.text = primaryDNS.split('.')[3];
        } else {
          primaryDNS1.text =
              primaryDNS2.text = primaryDNS3.text = primaryDNS4.text = "";
        }
        // 辅DNS
        secondaryDNS = netdata.ethernetSecondaryDns.toString();
        if (secondaryDNS != "" && secondaryDNS != null) {
          secondaryDNS1.text = secondaryDNS.split('.')[0];
          secondaryDNS2.text = secondaryDNS.split('.')[1];
          secondaryDNS3.text = secondaryDNS.split('.')[2];
          secondaryDNS4.text = secondaryDNS.split('.')[3];
        } else {
          secondaryDNS1.text =
              secondaryDNS2.text = secondaryDNS3.text = secondaryDNS4.text = "";
        }
      });
      getWanVal();
    } catch (e) {
      debugPrint('获取以太网设置失败：$e.toString()');
      Get.back();
      ToastUtils.error(S.current.requestFailed);
    }
  }

  bool _isLoading = false;

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(S.current.hint),
              content: Text(S.of(context).isRestart),
              actions: <Widget>[
                TextButton(
                  child: Text(S.current.cancel),
                  onPressed: () {
                    //取消
                    Navigator.pop(context, 'Cancle');
                  },
                ),
                TextButton(
                    child: Text(S.current.confirm),
                    onPressed: () {
                      //确定
                      if (wanIndex == 0) {
                        wanVal = 'nat';
                        setWanData();
                      }
                      if (wanIndex == 1) {
                        wanVal = 'bridge';
                        setWanData();
                      }
                      if (wanIndex == 2) {
                        wanVal = 'router';
                        setWanData();
                      }

                      Navigator.pop(context, "Ok");
                      //动态ip
                      if (showVal == S.current.DynamicIP) {
                        //isCheck选中不携带 优先级
                        //不携带 优先级 {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}
                        // 携带 优先级 {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"0","ethernetConnectPriority":"0","ethernetDetectServer":"1"}
                        isCheck
                            ? handleSave(
                                '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"1","ethernetDetectServer":"${server.text}"}')
                            : handleSave(
                                '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"0","ethernetConnectPriority":"${priorityVal == S.current.Ethernet ? '0' : '1'}","ethernetDetectServer":"${server.text}"}');
                      }
                      //静态ip
                      else if (showVal == S.current.staticIP) {
                        //isCheck选中不携带 优先级
                        //不携带 优先级 {"ethernetConnectMode":"static","ethernetIp":"172.16.20.224","ethernetMask":"255.255.255.0","ethernetDefaultGateway":"172.16.20.253","ethernetPrimaryDns":"114.114.114.114","ethernetSecondaryDns":"8.8.8.8","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}
                        // 携带 优先级{"ethernetConnectMode":"static","ethernetIp":"172.16.20.224","ethernetMask":"255.255.255.0","ethernetDefaultGateway":"172.16.20.253","ethernetPrimaryDns":"114.114.114.114","ethernetSecondaryDns":"8.8.8.8","ethernetMtu":"1500","ethernetConnectOnly":"0","ethernetConnectPriority":"1","ethernetDetectServer":"0"}
                        isCheck
                            ? handleSave(
                                '{"ethernetConnectMode":"static","ethernetIp":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetMask":"${maskVal1.text}.${maskVal2.text}.${maskVal3.text}.${maskVal4.text}","ethernetDefaultGateway":"${gatewayVal1.text}.${gatewayVal2.text}.${gatewayVal3.text}.${gatewayVal4.text}","ethernetPrimaryDns":"${primaryDNS1.text}.${primaryDNS2.text}.${primaryDNS3.text}.${primaryDNS4.text}","ethernetSecondaryDns":"${secondaryDNS1.text}.${secondaryDNS2.text}.${secondaryDNS3.text}.${secondaryDNS4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"1","ethernetDetectServer":"${server.text}"}')
                            : handleSave(
                                '{"ethernetConnectMode":"static","ethernetIp":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetMask":"${maskVal1.text}.${maskVal2.text}.${maskVal3.text}.${maskVal4.text}","ethernetDefaultGateway":"${gatewayVal1.text}.${gatewayVal2.text}.${gatewayVal3.text}.${gatewayVal4.text}","ethernetPrimaryDns":"${primaryDNS1.text}.${primaryDNS2.text}.${primaryDNS3.text}.${primaryDNS4.text}","ethernetSecondaryDns":"${secondaryDNS1.text}.${secondaryDNS2.text}.${secondaryDNS3.text}.${secondaryDNS4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"0","ethernetConnectPriority":"${priorityVal == S.current.Ethernet ? '0' : '1'}","ethernetDetectServer":"${server.text}"}');
                      }
                      // 仅LAN
                      else {
                        debugPrint(S.current.LANOnly);
                        //{"ethernetConnectMode":"lanonly","ethernetConnectOnly":"0","ethernetConnectPriority":"1"}
                        handleSave({
                          "ethernetConnectMode": "lanonly",
                          "ethernetConnectOnly":
                              priorityVal == S.current.Ethernet ? '0' : '1'
                        });
                      }
                    })
              ]);
        });
    setState(() {
      _isLoading = false;
    });
  }

  String wanShowVal = '';
  int wanIndex = 0;
  String wanVal = 'nat';
  WanSettingData wanSettingVal = WanSettingData();
  WanNetworkModel wanNetwork = WanNetworkModel();

  void getWanVal() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["networkWanSettingsMode"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wanSettingVal = WanSettingData.fromJson(d);
        if (wanSettingVal.networkWanSettingsMode.toString() == 'nat') {
          wanShowVal = 'NAT';
          wanIndex = 0;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'bridge') {
          wanShowVal = S.current.BRIDGE;
          wanIndex = 1;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'router') {
          wanShowVal = 'ROUTER';
          wanIndex = 2;
        }
      });
    } catch (e) {
      debugPrint('失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  void setWanData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"networkWanSettingsMode":"$wanVal"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          wanNetwork = WanNetworkModel.fromJson(d);
          if (wanNetwork.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        debugPrint(e.toString());
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: customAppbar(
            context: context,
            title: S.of(context).wanSettings,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(20.w),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
                  child: Row(
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      if (!_isLoading)
                        Text(
                          S.current.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _isLoading ? Colors.grey : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TitleWidger(title: S.of(context).wanSettings),
                      InfoBox(
                          boxCotainer: Column(
                        children: [
                          //连接模式
                          GestureDetector(
                            onTap: () {
                              closeKeyboard(context);
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: systemRouter == "0"
                                    ? [S.current.LANOnly]
                                    : [
                                        S.current.DynamicIP,
                                        S.current.staticIP,
                                        S.current.LANOnly
                                      ],
                                value: systemRouter == "0" ? 0 : val,
                              );
                              result?.then((selectedValue) => {
                                    if (selectedValue == 0)
                                      {
                                        setState(() {
                                          val = selectedValue!;
                                          showVal = S.current.LANOnly;
                                        })
                                      }
                                    else
                                      {
                                        if (val != selectedValue &&
                                            selectedValue != null)
                                          {
                                            setState(() => {
                                                  val = selectedValue,
                                                  showVal = [
                                                    S.current.DynamicIP,
                                                    S.current.staticIP,
                                                    S.current.LANOnly
                                                  ][val],
                                                })
                                          }
                                      }
                                  });
                            },
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).connectionMode,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Text(showVal,
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 5, 0, 0),
                                              fontSize: 14)),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        size: 30.w,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //仅以太网
                          Offstage(
                            offstage: showVal == S.current.LANOnly,
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).EthernetOnly,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Switch(
                                        value: isCheck,
                                        onChanged: (newVal) {
                                          setState(() {
                                            isCheck = newVal;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //优先级
                          Offstage(
                            offstage: isCheck || showVal == S.current.LANOnly,
                            child: GestureDetector(
                              onTap: () {
                                closeKeyboard(context);
                                var result = CommonPicker.showPicker(
                                  context: context,
                                  options: [S.current.Ethernet, '4G/5G'],
                                  value: priorityIndex,
                                );
                                result?.then((selectedValue) => {
                                      if (priorityIndex != selectedValue &&
                                          selectedValue != null)
                                        {
                                          setState(() => {
                                                priorityIndex = selectedValue,
                                                priorityVal = [
                                                  S.current.Ethernet,
                                                  '4G/5G'
                                                ][priorityIndex],
                                              })
                                        }
                                    });
                              },
                              child: BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).priority,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Text(priorityVal,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 5, 0, 0),
                                                fontSize: 14)),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: const Color.fromRGBO(
                                              144, 147, 153, 1),
                                          size: 30.w,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //------------------------------------------
                          //IP地址 ethernetIp
                          Offstage(
                            offstage: showVal != S.current.staticIP,
                            child: BottomLine(
                              height: 140,
                              rowtem: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).IPAddress,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OtpInput(ipVal1, false),
                                      const Text('.'),
                                      OtpInput(ipVal2, false),
                                      const Text('.'),
                                      OtpInput(ipVal3, false),
                                      const Text('.'),
                                      OtpInput(ipVal4, false),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //子网掩码 ethernetMask
                          Offstage(
                            offstage: showVal != S.current.staticIP,
                            child: BottomLine(
                              height: 140,
                              rowtem: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).SubnetMask),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OtpInput(maskVal1, false),
                                      const Text('.'),
                                      OtpInput(maskVal2, false),
                                      const Text('.'),
                                      OtpInput(maskVal3, false),
                                      const Text('.'),
                                      OtpInput(maskVal4, false),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //默认网关 ethernetDefaultGateway
                          Offstage(
                            offstage: showVal != S.current.staticIP,
                            child: BottomLine(
                              height: 140,
                              rowtem: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).DefaultGateway),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OtpInput(gatewayVal1, false),
                                      const Text('.'),
                                      OtpInput(gatewayVal2, false),
                                      const Text('.'),
                                      OtpInput(gatewayVal3, false),
                                      const Text('.'),
                                      OtpInput(gatewayVal4, false),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //主DNS ethernetPrimaryDns
                          Offstage(
                            offstage: showVal != S.current.staticIP,
                            child: BottomLine(
                              height: 140,
                              rowtem: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).PrimaryDNS),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OtpInput(primaryDNS1, false),
                                      const Text('.'),
                                      OtpInput(primaryDNS2, false),
                                      const Text('.'),
                                      OtpInput(primaryDNS3, false),
                                      const Text('.'),
                                      OtpInput(primaryDNS4, false),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //辅DNS ethernetSecondaryDns
                          Offstage(
                            offstage: showVal != S.current.staticIP,
                            child: BottomLine(
                              height: 140,
                              rowtem: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).SecondaryDNS),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OtpInput(secondaryDNS1, false),
                                      const Text('.'),
                                      OtpInput(secondaryDNS2, false),
                                      const Text('.'),
                                      OtpInput(secondaryDNS3, false),
                                      const Text('.'),
                                      OtpInput(secondaryDNS4, false),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //------------------------------------------
                          //MTU
                          Offstage(
                            offstage: showVal == S.current.LANOnly,
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('MTU',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  SizedBox(
                                    width: 400.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      controller: mtu,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: "576~1500",
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //检测服务器
                          Offstage(
                            offstage: showVal == S.current.LANOnly,
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Detect,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  SizedBox(
                                    width: 420.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: server,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: S.current.detectionServer,
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //网络模式
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: ['NAT', S.current.BRIDGE, 'ROUTER'],
                                value: wanIndex,
                              );
                              result?.then((selectedValue) => {
                                    if (wanIndex != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              wanIndex = selectedValue,
                                              wanShowVal = [
                                                'NAT',
                                                S.current.BRIDGE,
                                                'ROUTER'
                                              ][wanIndex],
                                              // if (wanIndex == 0)
                                              //   {
                                              //     wanVal = 'nat',
                                              //     setWanData()
                                              //     },
                                              // if (wanIndex == 1)
                                              //   {
                                              //     wanVal = 'bridge',
                                              //     setWanData()
                                              //   },
                                              // if (wanIndex == 2)
                                              //   {
                                              //     wanVal = 'router',
                                              //     setWanData()
                                              //   },
                                            })
                                      }
                                  });
                            },
                            child: BottomLine(
                              rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).NetworkMode,
                                        style: TextStyle(fontSize: 30.sp)),
                                    Row(
                                      children: [
                                        Text(wanShowVal,
                                            style: TextStyle(fontSize: 30.sp)),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: const Color.fromRGBO(
                                              144, 147, 153, 1),
                                          size: 30.w,
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ));
  }
}
