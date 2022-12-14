import 'package:flutter/material.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/topo/equipment_datas.dart';
import 'package:get/get.dart';

class TopoItem extends StatelessWidget {
  final String title;
  final bool isShow;
  final bool isNative;
  final OnlineDeviceTable? topoData;
  const TopoItem(
      {Key? key,
      required this.title,
      required this.isShow,
      required this.isNative,
      this.topoData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/access_equipment", arguments: topoData);
      },
      child: Column(
        children: [
          Stack(
            children: [
              CSSFilter.apply(
                value: CSSFilterMatrix().opacity(!isShow ? 0.3 : 1),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: 120.h,
                  width: 120.h,
                  margin: const EdgeInsets.all(5),
                  child: Image.network(
                      'https://z4a.net/images/2022/12/13/20221213-175814.jpg',
                      fit: BoxFit.cover),
                ),
              ),
              if (isNative)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 168, 168, 168),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    height: 16,
                    width: 30,
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      '本机',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: 22.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // const Text('datdadada'),
        ],
      ),
    );
  }
}
