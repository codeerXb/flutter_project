import 'package:flutter/material.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';

class TopoItem extends StatefulWidget {
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
  State<TopoItem> createState() => _TopoItemState();
}

class _TopoItemState extends State<TopoItem> {
  // int value = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Get.toNamed("/video_play");
        // if (widget.topoData!.mAC == 'B4:4C:3B:9E:46:3D') {
        // } else {
        //   Get.toNamed("/access_equipment", arguments: widget.topoData);
        // }
        // var result = CommonPicker.showPicker(
        //   context: context,
        //   options: ['高楼层', '中楼层', '低楼层'],
        //   value: value,
        // );
        // result?.then((selectedValue) => {
        //       if (value != selectedValue && selectedValue != null)
        //         {setState(() => value = selectedValue!)}
        //     });
      },
      child: Column(
        children: [
          Stack(
            children: [
              CSSFilter.apply(
                value: CSSFilterMatrix().opacity(!widget.isShow ? 0.3 : 1),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(25, 47, 90, 245),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: 120.w,
                  width: 120.w,
                  margin: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/slices.png',
                    // fit: BoxFit.cover,
                    width: 70.w,
                    height: 80.w,
                  ),
                ),
              ),
              if (widget.isNative)
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
              widget.title,
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
