import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/wifi_set/major/major_datas.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

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
        ToastUtils.toast( S.current.success);
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast( S.current.error);
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
        index = ['CN', 'FR', 'RU', 'US', 'SG', 'AU', 'CL', 'PL']
            .indexOf(majorData.wifiRegionCountry.toString());
        //读取地区
        switch (majorData.wifiRegionCountry.toString()) {
          case 'CN':
            showVal = S.current.China;
            break;
          case 'FR':
            showVal = S.current.France;
            break;
          case 'RU':
            showVal = S.current.Russia;
            break;
          case 'US':
            showVal = S.current.UnitedStates;
            break;
          case 'SG':
            showVal = S.current.Singapore;
            break;
          case 'AU':
            showVal = S.current.Australia;
            break;
          case 'CL':
            showVal = S.current.Chile;
            break;
          case 'PL':
            showVal = S.current.Poland;
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
        appBar: customAppbar(context: context, title: S.of(context).majorSet),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleWidger(title: S.of(context).majorSet),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //地区
                    GestureDetector(
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: [
                            S.current.China,
                            S.current.France,
                            S.current.Russia,
                            S.current.UnitedStates,
                            S.current.Singapore,
                            S.current.Australia,
                            S.current.Chile,
                            S.current.Poland
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
                                          S.current.China,
                                          S.current.France,
                                          S.current.Russia,
                                          S.current.UnitedStates,
                                          S.current.Singapore,
                                          S.current.Australia,
                                          S.current.Chile,
                                          S.current.Poland
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text( S.of(context).Region,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Row(
                            children: [
                              Text(showVal,
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
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
                  ],
                )),
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
        ));
  }
}
