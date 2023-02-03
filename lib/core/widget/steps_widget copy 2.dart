import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

/// @Author: tzh
///
/// @CreateDate: 2021/8/30 11:46
///
/// @Description: 自定义步骤条
///
const colora = Color(0xff68739f);
const colorb = Color(0xff8c95db);

class StepsWidget extends StatefulWidget {
  const StepsWidget({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      alignment: Alignment.center,
      child: Card(
          elevation: 10,
          shadowColor: const Color.fromARGB(104, 181, 190, 242),
          color: const Color.fromARGB(188, 249, 250, 250),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
            // side: const BorderSide(
            //   color: Color.fromARGB(255, 160, 160, 160),
            //   width: 1,
            // ),
          ),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 75.w,
                  // width: 300.w,
                  // decoration: const BoxDecoration(
                  //   color: Color.fromARGB(255, 137, 195, 250),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.currentIndex == 0
                            ? "自检中"
                            : widget.currentIndex == 1
                                ? "搜索中"
                                : widget.currentIndex == 2
                                    ? "完成"
                                    : widget.currentIndex == -2
                                        ? '复位中'
                                        : "未开始",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 28.sp),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.w)),
                      if (widget.currentIndex == 0 ||
                          widget.currentIndex == 1 ||
                          widget.currentIndex == -2)
                        SpinKitSpinningLines(
                          color: const Color(0XFF0EBD8D),
                          size: 40.0.w,
                        )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 16.w,
                    width: 95.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        color: widget.currentIndex < 0
                            ? const Color.fromARGB(255, 231, 231, 231)
                            : const Color.fromARGB(122, 80, 248, 103),
                        border: const Border(
                            top: BorderSide(color: Colors.black12),
                            left: BorderSide(color: Colors.black12),
                            right: BorderSide(color: Colors.black12),
                            bottom: BorderSide(
                              color: Colors.black12,
                            ))),
                  ),
                  Container(
                    height: 16.w,
                    width: 95.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        color: widget.currentIndex < 1
                            ? const Color.fromARGB(255, 231, 231, 231)
                            : const Color.fromARGB(122, 80, 248, 103),
                        border: const Border(
                            top: BorderSide(color: Colors.black12),
                            left: BorderSide(color: Colors.black12),
                            right: BorderSide(color: Colors.black12),
                            bottom: BorderSide(
                              color: Colors.black12,
                            ))),
                  ),
                  Container(
                    height: 16.w,
                    width: 95.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        color: widget.currentIndex < 2
                            ? const Color.fromARGB(255, 231, 231, 231)
                            : const Color.fromARGB(122, 80, 248, 103),
                        border: const Border(
                            top: BorderSide(color: Colors.black12),
                            left: BorderSide(color: Colors.black12),
                            right: BorderSide(color: Colors.black12),
                            bottom: BorderSide(
                              color: Colors.black12,
                            ))),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
