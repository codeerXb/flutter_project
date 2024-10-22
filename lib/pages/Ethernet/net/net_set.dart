import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/otp_input.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

/// 以太网设置
class NetSet extends StatefulWidget {
  const NetSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetSetState();
}

class _NetSetState extends State<NetSet> {
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
    getData();
    // timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {});
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

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

  //读取
  void getData() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectMode","ethernetConnectOnly","ethernetConnectPriority","ethernetIp","ethernetMask","ethernetDefaultGateway","ethernetPrimaryDns","ethernetSecondaryDns","ethernetMtu","ethernetDetectServer","systemCurrentPlatform","wifiEzmeshEnable"]',
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
      ToastUtils.error('Remote access restriction');
      Get.back();
    } finally {
      setState(() {
        loading = false;
      });
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
                      Navigator.pop(context);
                    })
              ]);
        });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: WaterLoading(
                color: Color.fromARGB(255, 65, 167, 251),
              ),
            ),
          )
        : Scaffold(
            appBar: customAppbar(
                context: context,
                title: S.of(context).EthernetSettings,
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
            body: GestureDetector(
              onTap: () => closeKeyboard(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 2000.h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TitleWidger(title: S.of(context).Settings),
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
                                    style: TextStyle(color: Colors.red),
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
                                    style: TextStyle(color: Colors.red),
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
                                    style: TextStyle(color: Colors.red),
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
                                    style: TextStyle(color: Colors.red),
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
                                    style: TextStyle(color: Colors.red),
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
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ));
  }
}
