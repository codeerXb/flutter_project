import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mac: '');
  int day = 0;
  int hour = 0;
  int min = 0;
  String sn = '';
  String Title = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
      editTitleVal.text = data.hostName.toString();
      Title = data.hostName.toString();
      sharedGetData('deviceSn', String).then(((res) {
        setState(() {
          sn = res.toString();
        });
      }));
    });

    var time = int.parse(data.leaseTime.toString());
    day = time ~/ (24 * 3600);
    hour = (time - day * 24 * 3600) ~/ 3600;
    min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
  }

//重设名称
  editName(String sn, String mac, String nickname) async {
    Map<String, dynamic> form = {
      'sn': sn,
      'mac': mac,
      'nickname': nickname,
    };
    var res = await App.post('${BaseConfig.cloudBaseUrl}/platform/cpeNick/nick',
        data: form);

    var d = json.decode(res.toString());
    if (d['code'] != 200) {
      ToastUtils.error(d['message']);
    } else {
      ToastUtils.success(d['message']);
      Navigator.pop(context);
      setState(() {
        Title = editTitleVal.text;
      });
    }
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());

  final TextEditingController editTitleVal = TextEditingController();

  editDeviceName() {
    //底部弹出Container
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            editTitleVal.text = Title;
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 40.w,
                right: 40.w,
                //将在输入框底部添加一个填充，以确保输入框不会被键盘遮挡。
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 30.w)),

                  //title
                  Text(
                    S.current.ModifyRemarks,
                    style: TextStyle(fontSize: 46.sp),
                  ),
                  Padding(padding: EdgeInsets.only(top: 46.w)),

                  //输入框
                  TextField(
                    autofocus: true,
                    controller: editTitleVal,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: S.current.pleaseEnter,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框中的内容
                          editTitleVal.clear();
                        },
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 20.w)),
                  //btn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //取消
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editTitleVal.text = Title;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300.w, 70.w),
                        ),
                        child: Text(S.current.cancel),
                      ),
                      //确定
                      ElevatedButton(
                        onPressed: () {
                          if (editTitleVal.text.isNotEmpty) {
                            editName(
                                sn, data.mac.toString(), editTitleVal.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300.w, 70.w),
                        ),
                        child: Text(S.current.confirm),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: Title,
        actions: [
          //编辑title icon
          InkWell(
            onTap: () {
              editDeviceName();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.edit_note_outlined,
                color: const Color.fromRGBO(144, 147, 153, 1),
                size: 70.w,
              ),
            ),
          )
        ],
        result: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            height: 1400.w,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  TitleWidger(title: S.current.deviceInfo),
                ]),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.current.MACAddress,
                        righText: data.mac.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).IPAddress,
                        righText: data.iP.toString(),
                      )),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: S.current.connectionMode,
                          righText: data.type.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                ),
                // 家长
                InfoBox(
                  boxCotainer: SizedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.toNamed("/parental_control", arguments: data);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.parentalControl,
                              style: TextStyle(fontSize: 30.sp)),
                          Row(
                            children: [
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
                ),
                // 游戏
                InfoBox(
                  boxCotainer: SizedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ToastUtils.toast(S.current.nogameAcceleration);
                        // Get.toNamed("/parental_control", arguments: data);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.gameAcceleration,
                              style: TextStyle(fontSize: 30.sp)),
                          Row(
                            children: [
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
                ),
                // AI
                InfoBox(
                  boxCotainer: SizedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ToastUtils.toast(S.current.noaivideo);
                        // Get.toNamed("/parental_control", arguments: data);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.aivideo,
                              style: TextStyle(fontSize: 30.sp)),
                          Row(
                            children: [
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
                ),
              ],
            )),
      ),
    );
  }
}
