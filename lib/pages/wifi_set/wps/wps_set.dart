import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/wifi_set/wps/wps_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

/// WPS设置

class WpsSet extends StatefulWidget {
  const WpsSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WpsSetState();
}

class _WpsSetState extends State<WpsSet> {
  wpsDatas wpsData = wpsDatas(
      wifiWpsClientPin: '',
      //WPS 1启动
      wifiWps: '',
      //模式
      wifiWpsMode: '');
  String showVal = '2.4GHz';
  int val = 0;
  bool isCheck = false;
  //wps选中
  String wpsVal = '0';
  //key  wifiWps/wifi5gWps
  dynamic paramKey = 'wifiWps';
  String modeShowVal = 'PBC';
  int modeVal = 0;
  dynamic parmas = '';
  final TextEditingController pinVal = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  //1 保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"$paramKey": "$wpsVal"}',
    };
    try {
      await XHttp.get('/data.html', data);
      ToastUtils.toast('修改成功');
    } catch (e) {
      debugPrint('wps设置失败:$e.toString()');
      ToastUtils.toast('修改失败');
    }
  }

  //2.保存模式
  void savePbc(params) async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': params,
    };
    try {
      await XHttp.get('/data.html', data);
      ToastUtils.toast('修改成功');
    } catch (e) {
      debugPrint('wps设置失败:$e.toString()');
      ToastUtils.toast('修改失败');
    }
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiBandGet","wifiWps","wifiWpsMode","wifiWpsClientPin","wifi5gWps","wifi5gWpsMode","wifi5gWpsClientPin"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wpsData = wpsDatas.fromJson(d);
        //频段的值
        showVal = wpsData.wifiWps.toString() == '1' ? '2.4GHz' : '5GHz';
        val = wpsData.wifiWps.toString() == '1' ? 0 : 1;
        //频段是2G/5G 提交时提交
        paramKey = wpsData.wifiWps.toString() == '0' ? 'wifiWps' : 'wifi5gWps';

        wpsVal = wpsData.wifi5gWps.toString();

        // 2G
        if (wpsData.wifiWps.toString() == '1') {
          //模式
          modeShowVal =
              wpsData.wifiWpsMode.toString() == 'client' ? 'Client PIN' : 'PBC';
          // 客户模式
          modeVal = ['PBC', 'client'].indexOf(wpsData.wifiWpsMode.toString());
          //pin值
          pinVal.text = wpsData.wifiWpsClientPin.toString();
          //wps选中
          isCheck = wpsData.wifiWps.toString() == '1' ? true : false;
        }
        //5g
        else {
          //模式
          modeShowVal = wpsData.wifi5gWpsMode.toString() == 'client'
              ? 'Client PIN'
              : 'PBC';
          // 客户模式
          modeVal = ['PBC', 'client'].indexOf(wpsData.wifi5gWpsMode.toString());
          //pin值
          pinVal.text = wpsData.wifi5gWpsClientPin.toString();
          //wps选中
          isCheck = wpsData.wifi5gWps.toString() == '1' ? true : false;
        }
      });
    } catch (e) {
      debugPrint('获取wps设置失败:$e.toString()');
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
        appBar: customAppbar(context: context, title: 'WPS设置'),
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
                  const TitleWidger(title: '设置'),
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
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal = ['2.4GHz', '5GHz'][val],
                                          //提交时改变key
                                          paramKey = val == 0
                                              ? 'wifiWps'
                                              : 'wifi5gWps',
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
                                  Text(showVal,
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
                      //WPS
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('WPS',
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
                                      wpsVal = newVal == false ? '0' : '1';
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //模式
                      Offstage(
                        offstage: !isCheck,
                        child: GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: ['PBC', 'Client PIN'],
                              value: modeVal,
                            );
                            result?.then((selectedValue) => {
                                  if (modeVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            modeVal = selectedValue,
                                            modeShowVal =
                                                ['PBC', 'Client PIN'][modeVal]
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
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(modeShowVal,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
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
                      //客户 PIN
                      Offstage(
                        offstage: modeShowVal == 'PBC' || !isCheck,
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('客户 PIN',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 100.w,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: pinVal,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
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
                          handleSave();
                          //选择PBC
                          if (isCheck && modeShowVal == 'PBC') {
                            savePbc('{"${paramKey}Mode": "$modeShowVal"}');
                          }
                          //选择Client PIN
                          if (isCheck && modeShowVal == 'Client PIN') {
                            showVal == '2.4GHz'
                                ? savePbc(
                                    '{ "${paramKey}Mode": "client",  "wifiWpsClientPin": "${pinVal.text}"}')
                                : savePbc(
                                    '{ "${paramKey}Mode": "client",  "wifi5gWpsClientPin": "${pinVal.text}"}');
                          }
                        },
                        child: Text(
                          '提交',
                          style: TextStyle(fontSize: 36.sp),
                        ),
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
