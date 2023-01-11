import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/wifi_set/major/major_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 专业设置
class MajorSet extends StatefulWidget {
  const MajorSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MajorSetState();
}

class _MajorSetState extends State<MajorSet> {
  String showVal = '';
  majorDatas majorData = majorDatas(wifiRegionCountry: 'CN');
  int index = 0;
  dynamic val = 'CN';
  @override
  void initState() {
    super.initState();
    getData();
  }

  //保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"wifiRegionCountry":"$val"}',
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
      'param': '["wifiRegionCountry","wifiWpsPbcState","wifi5gWpsPbcState"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        majorData = majorDatas.fromJson(d);
        index = ['CN', 'FR', 'RU', 'US', 'SG', 'AU', 'CL', 'PL'].indexOf(majorData.wifiRegionCountry.toString());
        //读取地区
        switch (majorData.wifiRegionCountry.toString()) {
          case 'CN':
            showVal = '中国';
            break;
          case 'FR':
            showVal = '法国';
            break;
          case 'RU':
            showVal = '俄罗斯';
            break;
          case 'US':
            showVal = '美国';
            break;
          case 'SG':
            showVal = '新加坡';
            break;
          case 'AU':
            showVal = '澳大利亚';
            break;
          case 'CL':
            showVal = '智利';
            break;
          case 'PL':
            showVal = '波兰';
            break;
        }
      });
    } catch (e) {
      debugPrint('获取专业设置失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '专业设置'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '专业设置'),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //地区
                    GestureDetector(
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: [
                            '中国',
                            '法国',
                            '俄罗斯',
                            '美国',
                            '新加坡',
                            '澳大利亚',
                            '智利',
                            '波兰'
                          ],
                          value: index,
                        );
                        result?.then((selectedValue) => {
                              if (index != selectedValue &&
                                  selectedValue != null)
                                {
                                  setState(() => {
                                        index = selectedValue,
                                        showVal = [
                                          '中国',
                                          '法国',
                                          '俄罗斯',
                                          '美国',
                                          '新加坡',
                                          '澳大利亚',
                                          '智利',
                                          '波兰'
                                        ][index],
                                        val = [
                                          'CN',
                                          'FR',
                                          'RU',
                                          'US',
                                          'SG',
                                          'AU',
                                          'CL',
                                          'PL'
                                        ][index],
                                      })
                                }
                            });
                      },
                      child: BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('地区',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 70.sp,
                            width: 650.sp,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 48, 118, 250))),
                              onPressed: () {
                                handleSave();
                              },
                              child: Text(
                                '提交',
                                style: TextStyle(fontSize: 36.sp),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
