import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widget/common_picker.dart';
import '../../../../generated/l10n.dart';

/// 4G访客2
class Visitor2 extends StatefulWidget {
  const Visitor2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Visitor2State();
}

class _Visitor2State extends State<Visitor2> {
  vis2gDatas data_2g = vis2gDatas();
  final TextEditingController ssidVal = TextEditingController();
  final TextEditingController maxVal = TextEditingController();
  final TextEditingController password = TextEditingController();
  WiFiSsidTable currentData = WiFiSsidTable(
    ssid: '',
  );
  //是否允许访问内网
  bool networkCheck = false;
  //隐藏SSID网络
  bool showSsid = false;
  //AP隔离
  bool apVAl = false;
  //安全
  String safeShowVal = 'WPA-psk&WPA2-PS';
  int safeIndex = 0;
  String safeVal = 'psk-mixed';
  //wpa加密
  String wpaShowVal = 'WPA-psk&WPA2-PS';
  int wpaIndex = 0;
  String wpaVal = 'aes';
  //密码
  bool passwordValShow = true;
  @override
  void initState() {
    super.initState();
    get2GData();
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //读取
  void get2GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_2g = vis2gDatas.fromJson(d);
        currentData = data_2g.wiFiSsidTable![2];
        //是否允许访问内网 0不启用
        networkCheck =
            currentData.allowAccessIntranet.toString() == '0' ? false : true;
        //ssid
        ssidVal.text = currentData.ssid.toString();
        //最大设备
        maxVal.text = currentData.maxClient.toString();
        //隐藏SSID网络
        showSsid = currentData.ssidHide.toString() == '0' ? false : true;
        //AP隔离  ApIsolate=='0' 不启用
        apVAl = currentData.apIsolate.toString() == '0' ? false : true;
        // 安全
        switch (currentData.encryption.toString().split('+')[0]) {
          case 'psk':
            safeShowVal = 'WPA-PSK';
            break;
          case 'psk2':
            safeShowVal = 'WPA2-PSK';
            break;
          case 'psk-mixed':
            safeShowVal = 'WPA-PSK&WPA2-PSK';
            break;
        }
        safeIndex = ['psk', 'psk2', 'psk-mixed']
            .indexOf(currentData.encryption.toString().split('+')[0]);
        safeVal = ['psk', 'psk2', 'psk-mixed'][safeIndex];
        //wpa加密
        if (currentData.encryption.toString().split('+').length == 3) {
          wpaShowVal = 'TKIP&AES';
          wpaIndex = 2;
        } else {
          currentData.encryption.toString().split('+')[1] == 'aes'
              ? wpaShowVal = S.current.aesRecommend
              : wpaShowVal = 'TKIP';
          currentData.encryption.toString().split('+')[1] == 'aes'
              ? wpaIndex = 0
              : wpaIndex = 1;
        }
        wpaVal = ['aes', 'tkip', 'tkip+aes'][wpaIndex];
        //密码
        password.text = currentData.key.toString();
      });
    } catch (e) {
      debugPrint('获取2.4GHZ失败:$e.toString()');
    }
  }

  //保存
  void handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'tab_set',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'guest2'),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 1000,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   TitleWidger(title: S.of(context).Settings),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //访客网络索引
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).NetworkIndex,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Text('2.4G_2',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                          ],
                        ),
                      ),
                      //是否允许访问内网
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).AllowAccess,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: networkCheck,
                                  onChanged: (newVal) {
                                    setState(() {
                                      networkCheck = newVal;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
                              width: 300.w,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                controller: ssidVal,
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    color: const Color(0xff051220)),
                                decoration: InputDecoration(
                                  hintText: "1~32位ASCII字符",
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
                      //最大设备数
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).Maximum,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            SizedBox(
                              width: 100.w,
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                controller: maxVal,
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    color: const Color(0xff051220)),
                                decoration: InputDecoration(
                                  hintText: "1~32",
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
                      //隐藏SSID网络
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).HideSSIDBroadcast,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: showSsid,
                                  onChanged: (newVal) {
                                    setState(() {
                                      showSsid = newVal;
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
                            Text(S.of(context).APIsolation,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: apVAl,
                                  onChanged: (newVal) {
                                    setState(() {
                                      apVAl = newVal;
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
                            options: [
                              'WPA-PSK',
                              'WPA2-PSK',
                              'WPA-PSK&WPA2-PSK'
                            ],
                            value: safeIndex,
                          );
                          result?.then((selectedValue) => {
                                if (safeIndex != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          safeIndex = selectedValue,
                                          safeShowVal = [
                                            'WPA-PSK',
                                            'WPA2-PSK',
                                            'WPA-PSK&WPA2-PSK'
                                          ][safeIndex],
                                          safeVal = [
                                            'psk',
                                            'psk2',
                                            'psk-mixed'
                                          ][safeIndex]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).Security,
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(safeShowVal,
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
                            options: [S.current.aesRecommend, 'TKIP', 'TKIP&AES'],
                            value: wpaIndex,
                          );
                          result?.then((selectedValue) => {
                                if (wpaIndex != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          wpaIndex = selectedValue,
                                          wpaShowVal = [
                                            S.current.aesRecommend,
                                            'TKIP',
                                            'TKIP&AES'
                                          ][wpaIndex],
                                          wpaVal = [
                                            'aes',
                                            'tkip',
                                            'tkip+aes'
                                          ][wpaIndex]
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).WPAEncry,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).Password,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          SizedBox(
                            height: 80.w,
                            width: 300.w,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              obscureText: passwordValShow,
                              controller: password,
                              style: TextStyle(
                                  fontSize: 26.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordValShow = !passwordValShow;
                                      });
                                    },
                                    icon: Icon(!passwordValShow
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                hintText: "8~63位ASCII字符",
                                hintStyle: TextStyle(
                                    fontSize: 26.sp,
                                    color: const Color(0xff737A83)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
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
                            handleSave(
                                '{"table":"WiFiSsidTable","value":[{"id":2,"AllowAccessIntranet":"${networkCheck ? "1" : "0"}","Ssid":"${ssidVal.text}","MaxClient":"${maxVal.text}","SsidHide":"${showSsid ? "1" : "0"}","ApIsolate":"${apVAl ? "1" : "0"}","Encryption":"$safeVal+$wpaVal","ShowPasswd":"0","Key":"${password.text}"}]}');
                          },
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(fontSize: 30.sp),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
