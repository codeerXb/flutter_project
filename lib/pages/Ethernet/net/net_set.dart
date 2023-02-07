import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/otp_input.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

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
  String showVal = '动态ip';
  int val = 0;
  //优先级
  String priorityVal = '以太网';
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
        ToastUtils.toast('修改成功');
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('修改失败');
    });
  }

  //读取
  void getData() async {
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
            showVal = '动态ip';
            break;
          case 'static':
            showVal = '静态ip';
            break;
          case 'lanonly':
            showVal = '仅LAN';
            break;
        }
        val = ['dhcp', 'static', 'lanonly']
            .indexOf(netdata.ethernetConnectMode.toString());
        //仅以太网
        isCheck = netdata.ethernetConnectOnly.toString() == '1' ? true : false;
        //优先级 == '1' 4g
        priorityVal =
            netdata.ethernetConnectPriority.toString() == '1' ? '4G/5G' : '以太网';
        priorityIndex = ['以太网', '4G/5G'].indexOf(priorityVal);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '以太网设置'),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 2000.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TitleWidger(title: '设置'),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //连接模式
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['动态ip', '静态ip', '仅LAN'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal =
                                              ['动态ip', '静态ip', '仅LAN'][val],
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('连接模式',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(showVal,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 5, 0, 0),
                                          fontSize: 14)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
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
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('仅以太网',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
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
                        offstage: isCheck || showVal == '仅LAN',
                        child: GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: ['以太网', '4G/5G'],
                              value: priorityIndex,
                            );
                            result?.then((selectedValue) => {
                                  if (priorityIndex != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            priorityIndex = selectedValue,
                                            priorityVal =
                                                ['以太网', '4G/5G'][priorityIndex],
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('优先级',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(priorityVal,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 5, 0, 0),
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
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'IP地址',
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
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('子网掩码'),
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
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('默认网关'),
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
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('主DNS'),
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
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('辅DNS'),
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
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MTU',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
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
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('检测服务器',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
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
                                    hintText: "输入检测服务器",
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
                  //提交
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Center(
                        child: SizedBox(
                      height: 70.sp,
                      width: 680.sp,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 48, 118, 250))),
                        onPressed: () {
                          //对话框
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: const Text("提示"),
                                    content: const Text("提交后设备将会重启，是否继续?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("取消"),
                                        onPressed: () {
                                          //取消
                                          Navigator.pop(context, 'Cancle');
                                        },
                                      ),
                                      TextButton(
                                          child: const Text("确定"),
                                          onPressed: () {
                                            //确定
                                            Navigator.pop(context, "Ok");
                                            Navigator.push(context,
                                                DialogRouter(LoadingDialog()));
                                            //动态ip
                                            if (showVal == '动态ip') {
                                              //isCheck选中不携带 优先级
                                              //不携带 优先级 {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}
                                              // 携带 优先级 {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"0","ethernetConnectPriority":"0","ethernetDetectServer":"1"}
                                              isCheck
                                                  ? handleSave(
                                                      '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"1","ethernetDetectServer":"${server.text}"}')
                                                  : handleSave(
                                                      '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"0","ethernetConnectPriority":"${priorityVal == '以太网' ? '0' : '1'}","ethernetDetectServer":"${server.text}"}');
                                            }
                                            //静态ip
                                            else if (showVal == '静态ip') {
                                              //isCheck选中不携带 优先级
                                              //不携带 优先级 {"ethernetConnectMode":"static","ethernetIp":"172.16.20.224","ethernetMask":"255.255.255.0","ethernetDefaultGateway":"172.16.20.253","ethernetPrimaryDns":"114.114.114.114","ethernetSecondaryDns":"8.8.8.8","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}
                                              // 携带 优先级{"ethernetConnectMode":"static","ethernetIp":"172.16.20.224","ethernetMask":"255.255.255.0","ethernetDefaultGateway":"172.16.20.253","ethernetPrimaryDns":"114.114.114.114","ethernetSecondaryDns":"8.8.8.8","ethernetMtu":"1500","ethernetConnectOnly":"0","ethernetConnectPriority":"1","ethernetDetectServer":"0"}
                                              isCheck
                                                  ? handleSave(
                                                      '{"ethernetConnectMode":"static","ethernetIp":"${fDNSVal1.text}.${fDNSVal2.text}.${fDNSVal3.text}.${fDNSVal4.text}","ethernetMask":"${zwVal1.text}.${zwVal2.text}.${zwVal3.text}.${zwVal4.text}","ethernetDefaultGateway":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetPrimaryDns":"${mrwgVal1.text}.${mrwgVal2.text}.${mrwgVal3.text}.${mrwgVal4.text}","ethernetSecondaryDns":"${zdnsVal1.text}.${zdnsVal2.text}.${zdnsVal3.text}.${zdnsVal4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"1","ethernetDetectServer":"${server.text}"}')
                                                  : handleSave(
                                                      '{"ethernetConnectMode":"static","ethernetIp":"${fDNSVal1.text}.${fDNSVal2.text}.${fDNSVal3.text}.${fDNSVal4.text}","ethernetMask":"${zwVal1.text}.${zwVal2.text}.${zwVal3.text}.${zwVal4.text}","ethernetDefaultGateway":"${ipVal1.text}.${ipVal2.text}.${ipVal3.text}.${ipVal4.text}","ethernetPrimaryDns":"${mrwgVal1.text}.${mrwgVal2.text}.${mrwgVal3.text}.${mrwgVal4.text}","ethernetSecondaryDns":"${zdnsVal1.text}.${zdnsVal2.text}.${zdnsVal3.text}.${zdnsVal4.text}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"0","ethernetConnectPriority":"${priorityVal == '以太网' ? '0' : '1'}","ethernetDetectServer":"${server.text}"}');
                                            }
                                            // 仅LAN
                                            else {
                                              debugPrint('仅LAN');
                                              //{"ethernetConnectMode":"lanonly","ethernetConnectOnly":"0","ethernetConnectPriority":"1"}
                                              handleSave({
                                                "ethernetConnectMode":
                                                    "lanonly",
                                                "ethernetConnectOnly":
                                                    priorityVal == '以太网'
                                                        ? '0'
                                                        : '1'
                                              });
                                            }
                                          })
                                    ]);
                              });
                        },
                        child: Text(
                          '提交',
                          style: TextStyle(fontSize: 36.sp),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
