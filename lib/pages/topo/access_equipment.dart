import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  int day = 0;
  int hour = 0;
  int min = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });

    var time = int.parse(data.leaseTime.toString());
    day = time ~/ (24 * 3600);
    hour = (time - day * 24 * 3600) ~/ 3600;
    min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: data.hostName.toString()),
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
                        righText: data.mAC.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).IPAddress,
                        righText: data.iP.toString(),
                      )),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: S.current.LeaseTime,
                          righText: day.toString() +
                              S.of(context).date +
                              hour.toString() +
                              S.of(context).hour +
                              min.toString() +
                              S.of(context).minute,
                        ),
                      ),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: S.current.type,
                          righText: data.type.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                ),
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
                            Text('家长控制', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                InfoBox(
                  boxCotainer: SizedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ToastUtils.toast('暂未订阅 游戏加速 ,请前往 "订阅服务" 订阅');
                        // Get.toNamed("/parental_control", arguments: data);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('游戏加速', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                InfoBox(
                  boxCotainer: SizedBox(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ToastUtils.toast('暂未订阅 AI视频 ,请前往 "订阅服务" 订阅');
                        // Get.toNamed("/parental_control", arguments: data);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('AI视频', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
