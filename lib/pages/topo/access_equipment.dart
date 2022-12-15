import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/setting/equ_info.dart';
import 'package:flutter_template/pages/topo/equipment_datas.dart';
import 'package:get/get.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
    print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'AAA-data'),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            InfoBox(
              boxCotainer: Column(
                children: [
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: 'MAC地址',
                    righText: data.mAC.toString(),
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: 'IP地址',
                    righText: data.iP.toString(),
                  )),
                  BottomLine(
                    rowtem: RowContainer(
                      leftText: '租约时间',
                      righText: data.leaseTime.toString(),
                    ),
                  ),
                  BottomLine(
                    rowtem: RowContainer(
                      leftText: '类型',
                      righText: data.type.toString(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}