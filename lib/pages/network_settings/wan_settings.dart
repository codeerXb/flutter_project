import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/otp_input.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/network_settings/model/wan_data.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

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
  final TextEditingController mtu = TextEditingController();
  final TextEditingController server = TextEditingController();
  dynamic ipVal = '';
  final TextEditingController ipVal1 = TextEditingController();
  final TextEditingController ipVal2 = TextEditingController();
  final TextEditingController ipVal3 = TextEditingController();
  final TextEditingController ipVal4 = TextEditingController();
  dynamic zwVal = '';
  final TextEditingController zwVal1 = TextEditingController();
  final TextEditingController zwVal2 = TextEditingController();
  final TextEditingController zwVal3 = TextEditingController();
  final TextEditingController zwVal4 = TextEditingController();
  dynamic mrwgVal = '';
  final TextEditingController mrwgVal1 = TextEditingController();
  final TextEditingController mrwgVal2 = TextEditingController();
  final TextEditingController mrwgVal3 = TextEditingController();
  final TextEditingController mrwgVal4 = TextEditingController();
  dynamic zdnsVal = '';
  final TextEditingController zdnsVal1 = TextEditingController();
  final TextEditingController zdnsVal2 = TextEditingController();
  final TextEditingController zdnsVal3 = TextEditingController();
  final TextEditingController zdnsVal4 = TextEditingController();
  dynamic fDNSVal = '';
  final TextEditingController fDNSVal1 = TextEditingController();
  final TextEditingController fDNSVal2 = TextEditingController();
  final TextEditingController fDNSVal3 = TextEditingController();
  final TextEditingController fDNSVal4 = TextEditingController();
  @override
  void initState() {
    super.initState();
    loginFn();
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
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  bool loading = false;
  final LoginController loginController = Get.put(LoginController());

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","ethernetConnectMode","ethernetConnectOnly","ethernetConnectPriority","ethernetIp","ethernetMask","ethernetDefaultGateway","ethernetPrimaryDns","ethernetSecondaryDns","ethernetMtu","ethernetDetectServer","systemCurrentPlatform","wifiEzmeshEnable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
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
        ipVal1.text = ipVal.split('.')[0];
        ipVal2.text = ipVal.split('.')[1];
        ipVal3.text = ipVal.split('.')[2];
        ipVal4.text = ipVal.split('.')[3];
        // 子网掩码
        zwVal = netdata.ethernetMask.toString();
        zwVal1.text = zwVal.split('.')[0];
        zwVal2.text = zwVal.split('.')[1];
        zwVal3.text = zwVal.split('.')[2];
        zwVal4.text = zwVal.split('.')[3];
        // 默认网关
        ipVal = netdata.ethernetDefaultGateway.toString();
        ipVal1.text = ipVal.split('.')[0];
        ipVal2.text = ipVal.split('.')[1];
        ipVal3.text = ipVal.split('.')[2];
        ipVal4.text = ipVal.split('.')[3];
        // 主DNS
        mrwgVal = netdata.ethernetPrimaryDns.toString();
        mrwgVal1.text = mrwgVal.split('.')[0];
        mrwgVal2.text = mrwgVal.split('.')[1];
        mrwgVal3.text = mrwgVal.split('.')[2];
        mrwgVal4.text = mrwgVal.split('.')[3];
        // 辅DNS
        zdnsVal = netdata.ethernetSecondaryDns.toString();
        zdnsVal1.text = zdnsVal.split('.')[0];
        zdnsVal2.text = zdnsVal.split('.')[1];
        zdnsVal3.text = zdnsVal.split('.')[2];
        zdnsVal4.text = zdnsVal.split('.')[3];

        fDNSVal = netdata.ethernetIp.toString();
        fDNSVal1.text = fDNSVal.split('.')[0];
        fDNSVal2.text = fDNSVal.split('.')[1];
        fDNSVal3.text = fDNSVal.split('.')[2];
        fDNSVal4.text = fDNSVal.split('.')[3];
      });
    } catch (e) {
      debugPrint('获取以太网设置失败：$e.toString()');
      // ToastUtils.error('Remote access restriction');
    } finally {}
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
              content: Text(S.of(context).isGoOn),
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
                                '{"ethernetConnectMode":"static","ethernetIp":"${fDNSVal1.text}.${fDNSVal2.text}.${fDNSVal3.text}.${fDNSVal4.text}","ethernetMask":"${zwVal1.text}.${zwVal2.text}.${zwVal3.text}.${zwVal4.text}","ethernetDefaultGateway":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetPrimaryDns":"${mrwgVal1.text}.${mrwgVal2.text}.${mrwgVal3.text}.${mrwgVal4.text}","ethernetSecondaryDns":"${zdnsVal1.text}.${zdnsVal2.text}.${zdnsVal3.text}.${zdnsVal4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"1","ethernetDetectServer":"${server.text}"}')
                            : handleSave(
                                '{"ethernetConnectMode":"static","ethernetIp":"${fDNSVal1.text}.${fDNSVal2.text}.${fDNSVal3.text}.${fDNSVal4.text}","ethernetMask":"${zwVal1.text}.${zwVal2.text}.${zwVal3.text}.${zwVal4.text}","ethernetDefaultGateway":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetPrimaryDns":"${mrwgVal1.text}.${mrwgVal2.text}.${mrwgVal3.text}.${mrwgVal4.text}","ethernetSecondaryDns":"${zdnsVal1.text}.${zdnsVal2.text}.${zdnsVal3.text}.${zdnsVal4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"0","ethernetConnectPriority":"${priorityVal == S.current.Ethernet ? '0' : '1'}","ethernetDetectServer":"${server.text}"}');
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

  void loginout() {
    // 这里还需要调用后台接口的方法
    sharedDeleteData("loginInfo");
    sharedClearData();
    Get.offAllNamed("/get_equipment");
  }

//没有登录去登录
  bool gotoLogin = false;
  void loginFn() async {
    setState(() {
      loading = true;
        _isLoading=true;

    });
    var deviceSn = await sharedGetData('deviceSn', String);
    setState(() {
      sn = deviceSn.toString();
    });
    var res = await sharedGetData(sn, String);

    var userInfo = jsonDecode(res.toString());
    var user = userInfo["user"];
    var pwd = utf8.decode(base64Decode(userInfo["pwd"]));

    var response = await XHttp.get('/action/appLogin', {
      'username': user,
      'password': pwd,
    });

    var d = json.decode(response.toString());
    loginController.setSession(d['sessionid']);
    sharedAddAndUpdate("session", String, d['sessionid']);
    loginController.setToken(d['token']);
    sharedAddAndUpdate("token", String, d['token']);
    // print('登录状态${d['code']}');
    if (d['code'] == 200) {
      getData();
      getWanVal();
      setState(() {
        loading = false;
        _isLoading=false;

      });
    } else if (d['code'] == DioErrorType.connectTimeout) {
      //超时返回上一页
      debugPrint('timeout');
      Get.back();
      ToastUtils.error(S.current.contimeout);
      setState(() {
        loading = false;
        _isLoading=false;

      });
    } else if (d['code'] == 201) {
      //用户名或密码错误 去登录
      ToastUtils.toast(
          '${S.current.passError}${5 - int.parse(d.webLoginFailedTimes.toString())}');
      setState(() {
        gotoLogin = true;
        _isLoading=false;
        loading = false;
      });
    } else if (d['code'] == 202) {
      ToastUtils.error(
          '${S.current.locked}${d.webLoginRetryTimeout}${S.current.unlock}');
      setState(() {
        gotoLogin = true;
        loading = false;
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context,
            title: S.of(context).wanSettings,
            actions: <Widget>[
              if (gotoLogin == false)
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
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () => closeKeyboard(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1)),
                  height: 2000.h,
                  child: Center(
                    child: Column(
                      children: [
                        if (gotoLogin == false)
                          SingleChildScrollView(
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
                                          options: [
                                            S.current.DynamicIP,
                                            S.current.staticIP,
                                            S.current.LANOnly
                                          ],
                                          value: val,
                                        );
                                        result?.then((selectedValue) => {
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
                                                        color: Color.fromARGB(
                                                            255, 5, 0, 0),
                                                        fontSize: 14)),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
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
                                      offstage: isCheck ||
                                          showVal == S.current.LANOnly,
                                      child: GestureDetector(
                                        onTap: () {
                                          closeKeyboard(context);
                                          var result = CommonPicker.showPicker(
                                            context: context,
                                            options: [
                                              S.current.Ethernet,
                                              '4G/5G'
                                            ],
                                            value: priorityIndex,
                                          );
                                          result?.then((selectedValue) => {
                                                if (priorityIndex !=
                                                        selectedValue &&
                                                    selectedValue != null)
                                                  {
                                                    setState(() => {
                                                          priorityIndex =
                                                              selectedValue,
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
                                                      color:
                                                          const Color.fromARGB(
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
                                                    Icons
                                                        .arrow_forward_ios_outlined,
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
                                        rowtem: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              S.of(context).IPAddress,
                                            ),
                                            OtpInput(ipVal1, false),
                                            const Text('.'),
                                            OtpInput(ipVal2, false),
                                            const Text('.'),
                                            OtpInput(ipVal3, false),
                                            const Text('.'),
                                            OtpInput(ipVal4, false),
                                            const Text(
                                              '*',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //子网掩码 ethernetMask
                                    Offstage(
                                      offstage: showVal != S.current.staticIP,
                                      child: BottomLine(
                                        rowtem: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(S.of(context).SubnetMask),
                                            OtpInput(zwVal1, false),
                                            const Text('.'),
                                            OtpInput(zwVal2, false),
                                            const Text('.'),
                                            OtpInput(zwVal3, false),
                                            const Text('.'),
                                            OtpInput(zwVal4, false),
                                            const Text(
                                              '*',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //默认网关 ethernetDefaultGateway
                                    Offstage(
                                      offstage: showVal != S.current.staticIP,
                                      child: BottomLine(
                                        rowtem: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(S.of(context).DefaultGateway),
                                            OtpInput(mrwgVal1, false),
                                            const Text('.'),
                                            OtpInput(mrwgVal2, false),
                                            const Text('.'),
                                            OtpInput(mrwgVal3, false),
                                            const Text('.'),
                                            OtpInput(mrwgVal4, false),
                                            const Text(
                                              '*',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //主DNS ethernetPrimaryDns
                                    Offstage(
                                      offstage: showVal != S.current.staticIP,
                                      child: BottomLine(
                                        rowtem: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(S.of(context).PrimaryDNS),
                                            OtpInput(zdnsVal1, false),
                                            const Text('.'),
                                            OtpInput(zdnsVal2, false),
                                            const Text('.'),
                                            OtpInput(zdnsVal3, false),
                                            const Text('.'),
                                            OtpInput(zdnsVal4, false),
                                            const Text(
                                              '*',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //辅DNS ethernetSecondaryDns
                                    Offstage(
                                      offstage: showVal != S.current.staticIP,
                                      child: BottomLine(
                                        rowtem: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(S.of(context).SecondaryDNS),
                                            OtpInput(fDNSVal1, false),
                                            const Text('.'),
                                            OtpInput(fDNSVal2, false),
                                            const Text('.'),
                                            OtpInput(fDNSVal3, false),
                                            const Text('.'),
                                            OtpInput(fDNSVal4, false),
                                            const Text(
                                              '*',
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: mtu,
                                                style: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff051220)),
                                                decoration: InputDecoration(
                                                  hintText: "576~1500",
                                                  hintStyle: TextStyle(
                                                      fontSize: 26.sp,
                                                      color: const Color(
                                                          0xff737A83)),
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
                                                    color: const Color(
                                                        0xff051220)),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      S.current.detectionServer,
                                                  hintStyle: TextStyle(
                                                      fontSize: 26.sp,
                                                      color: const Color(
                                                          0xff737A83)),
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
                                          options: [
                                            'NAT',
                                            S.current.BRIDGE,
                                            'ROUTER'
                                          ],
                                          value: wanIndex,
                                        );
                                        result?.then((selectedValue) => {
                                              if (wanIndex != selectedValue &&
                                                  selectedValue != null)
                                                {
                                                  setState(() => {
                                                        wanIndex =
                                                            selectedValue,
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
                                                  style: TextStyle(
                                                      fontSize: 30.sp)),
                                              Row(
                                                children: [
                                                  Text(wanShowVal,
                                                      style: TextStyle(
                                                          fontSize: 30.sp)),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
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
                        if (gotoLogin == true)
                          // 登录失败请重新登录设备
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('登录失败点击确认重新登录设备'),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(200, 30),
                                    backgroundColor: const Color.fromARGB(
                                        255, 30, 104, 233)),
                                onPressed: () {
                                  Get.toNamed("/wan_login",
                                      arguments: {"sn": sn});
                                },
                                child: Text(S.of(context).confirm),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
