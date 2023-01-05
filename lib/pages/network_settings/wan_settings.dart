import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/network_settings/model/wan_data.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_picker.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  WanSettingData wanSettingVal = WanSettingData();
  String showVal = '';
  int val = 0;
  String wanVal = 'nat';

  WanNetworkModel wanNetwork = WanNetworkModel();

  @override
  void initState() {
    super.initState();
    getWanVal();
  }

  void getWanData() {
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
            ToastUtils.toast('修改成功');
          } else {
            ToastUtils.toast('修改失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast('修改失败');
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('修改失败');
    });
  }

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
          showVal = 'NAT';
          val = 0;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'bridge') {
          showVal = '桥接';
          val = 1;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'router') {
          showVal = 'ROUTER';
          val = 2;
        }
      });
    } catch (e) {
      debugPrint('失败：$e.toString()');
      ToastUtils.toast('修改失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'WAN设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 40.sp,
              ),
              Padding(padding: EdgeInsets.only(top: 30.sp)),
              InfoBox(
                boxCotainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('网络模式',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 0, 0),
                              fontSize: 32.sp)),
                      GestureDetector(
                        onTap: () {
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['NAT', '桥接', 'ROUTER'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal =
                                              ['NAT', '桥接', 'ROUTER'][val],
                                          if (val == 0)
                                            {wanVal = 'nat', getWanData()},
                                          if (val == 1)
                                            {wanVal = 'bridge', getWanData()},
                                          if (val == 2)
                                            {wanVal = 'router', getWanData()},
                                        })
                                  }
                              });
                        },
                        child: Row(
                          children: [
                            Text(showVal,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 32.sp)),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: const Color.fromRGBO(144, 147, 153, 1),
                              size: 30.w,
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 60.sp,
              ),
            ])),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0.sp),
        margin: EdgeInsets.only(bottom: 5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
