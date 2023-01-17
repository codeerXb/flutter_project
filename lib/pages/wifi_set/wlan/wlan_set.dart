import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/wifi_set/wlan/wlan_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

/// WLAN设置
class WlanSet extends StatefulWidget {
  const WlanSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanSetState();
}

class _WlanSetState extends State<WlanSet> {
  wlanDatas wlanData = wlanDatas(
      wifiEnable: "1",
      wifiMode: "11axg",
      wifiHtmode: "--",
      wifiChannel: "auto",
      wifiTxpower: "20",
      wifi5gEnable: "1",
      wifi5gMode: "11axa",
      wifi5gHtmode: "80MHz",
      wifi5gChannel: "auto",
      wifi5gTxpower: "24");
  //频段
  String pdShowVal = '2.4GHz';
  int pdVal = 0;
  //模式
  String msShowVal = '802.11n/g';
  int msVal = 0;
  //带宽
  String kdShowVal = '20 MHz';
  int kdVal = 0;
  //信道
  String xtShowVal = 'Auto';
  int xtVal = 0;
  //发射功率
  String fsShowVal = '100%';
  int fsVal = 0;
  //安全
  String aqShowVal = 'WPA2-PSK';
  int aqVal = 0;
  //WPA加密
  String wpaShowVal = 'AES(推荐)';
  int wpaVal = 0;
  //check
  bool isCheck = true;
  bool apisCheck = true;
  bool ssidisCheck = true;
  final TextEditingController ssid = TextEditingController();
  final TextEditingController max = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiBandGet","wifiEnable","wifiMode","wifiHtmode","wifiChannel","wifiTxpower","Ssid","MaxClient","SsidHide","ApIsolate","wlanencryption","wlanauthentication","Key","wifi5gEnable","wifi5gMode","wifi5gHtmode","wifi5gHtmode1","wifi5gChannel","wifi5gTxpower","Ssid5g","MaxClient5g","SsidHide5g","ApIsolate5g","wlanencryption5g","wlanauthentication5g","Key5g"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wlanData = wlanDatas.fromJson(d);
        //SSID
        ssid.text = wlanData.wifiChannel.toString();
        max.text = wlanData.wifiTxpower.toString();
        password.text = wlanData.wifi5gMode.toString();
      });
    } catch (e) {
      debugPrint('设置失败:$e.toString()');
    }
  }

  void get() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wlanData = wlanDatas.fromJson(d);
        //SSID
        ssid.text = wlanData.wifiChannel.toString();
        max.text = wlanData.wifiTxpower.toString();
        password.text = wlanData.wifi5gMode.toString();
      });
    } catch (e) {
      debugPrint('设置失败:$e.toString()');
    }
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WLAN设置'),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.all(20.0.w),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 2000.w,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //一般设置
                  const TitleWidger(title: '一般设置'),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //频段
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['2.4GHz', '5GHz'],
                            value: pdVal,
                          );
                          result?.then((selectedValue) => {
                                if (pdVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          pdVal = selectedValue,
                                          pdShowVal = ['2.4GHz', '5GHz'][pdVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('频段',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(pdShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //WLAN
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('WLAN',
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
                      //模式
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: [
                              '802.11n/g',
                              '802.11axg',
                              '802.11g Only',
                              '802.11b Only'
                            ],
                            value: msVal,
                          );
                          result?.then((selectedValue) => {
                                if (msVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          msVal = selectedValue,
                                          msShowVal = [
                                            '802.11n/g',
                                            '802.11axg',
                                            '802.11g Only',
                                            '802.11b Only'
                                          ][msVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('模式',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(msShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //带宽
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: [
                              '20 MHz',
                              '20/40 MHz',
                            ],
                            value: kdVal,
                          );
                          result?.then((selectedValue) => {
                                if (kdVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          kdVal = selectedValue,
                                          kdShowVal = [
                                            '20 MHz',
                                            '20/40 MHz',
                                          ][kdVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('带宽',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(kdShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //信道
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: [
                              'Auto',
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10',
                              '11',
                              '12',
                              '13'
                            ],
                            value: xtVal,
                          );
                          result?.then((selectedValue) => {
                                if (xtVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          xtVal = selectedValue,
                                          xtShowVal = [
                                            'Auto',
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                            '5',
                                            '6',
                                            '7',
                                            '8',
                                            '9',
                                            '10',
                                            '11',
                                            '12',
                                            '13'
                                          ][xtVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('信道',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(xtShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //发射功率
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: [
                              '100%',
                              '50%',
                              '20%',
                            ],
                            value: fsVal,
                          );
                          result?.then((selectedValue) => {
                                if (fsVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          fsVal = selectedValue,
                                          fsShowVal = [
                                            '100%',
                                            '50%',
                                            '20%',
                                          ][fsVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('发射功率',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(fsShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                    ],
                  )),
                  //配置
                  const TitleWidger(title: '配置'),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //SSID
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SSID',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            SizedBox(
                              width: 250.w,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250.w,
                                    child: TextFormField(
                                      controller: ssid,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: "输入SSID",
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Text("")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //最大设备数
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('最大设备数',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            SizedBox(
                              width: 250.w,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250.w,
                                    child: TextFormField(
                                      controller: max,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: "最大设备数",
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Text("")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //隐藏SSID网络
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('隐藏SSID网络',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: ssidisCheck,
                                  onChanged: (newVal) {
                                    setState(() {
                                      ssidisCheck = newVal;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //AP隔离
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('AP隔离',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: apisCheck,
                                  onChanged: (newVal) {
                                    setState(() {
                                      apisCheck = newVal;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //安全
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['WPA2-PSK', 'WPA-PSK&WPA2-PSK', '空(不推荐)'],
                            value: aqVal,
                          );
                          result?.then((selectedValue) => {
                                if (aqVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          aqVal = selectedValue,
                                          aqShowVal = [
                                            'WPA2-PSK',
                                            'WPA-PSK&WPA2-PSK',
                                            '空(不推荐)'
                                          ][aqVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('安全',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(aqShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //WPA加密
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: [
                              'AES(推荐)'
                                  'TKIP',
                              'TKIP&AES',
                            ],
                            value: wpaVal,
                          );
                          result?.then((selectedValue) => {
                                if (wpaVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          wpaVal = selectedValue,
                                          wpaShowVal = [
                                            'AES(推荐)'
                                                'TKIP',
                                            'TKIP&AES',
                                          ][wpaVal]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('WPA加密',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(wpaShowVal,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
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
                      //密码
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "密码",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp),
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250.w,
                                    child: TextFormField(
                                      controller: password,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: "输入新密码",
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Text("")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  //提交
                  Center(
                      child: SizedBox(
                    height: 70.sp,
                    width: 650.sp,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {},
                      child: Text(
                        '提交',
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
