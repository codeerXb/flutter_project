import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
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
    wifi5gWpsClientPin: '',
  );
  String showVal = '2.4GHz';
  int val = 0;
  bool isCheck = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  //保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '',
    };
    try {
      await XHttp.get('/data.html', data);
    } catch (e) {
      debugPrint('wps设置失败：$e.toString()');
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
      });
    } catch (e) {
      debugPrint('获取wps设置失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WPS设置'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '设置'),
                ElevatedButton(
                    onPressed: () {
                      handleSave();
                    },
                    child: const Text('保存')),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //频段
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('频段',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
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
                                              showVal = ['2.4GHz', '5GHz'][val]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(showVal,
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ),
                        ],
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
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
