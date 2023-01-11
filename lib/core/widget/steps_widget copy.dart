import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @Author: tzh
///
/// @CreateDate: 2021/8/30 11:46
///
/// @Description: 自定义步骤条
///
const Colora = Color(0xff68739f);
const Colorb = Color(0xff8c95db);

class StepsWidget extends StatefulWidget {
  const StepsWidget({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  _StepsWidgetState createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  var _items = ["自检", "搜索", "完成"];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: 100.h,
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.only(
                      top: 10.w, bottom: 10.w, left: 30.w, right: 30.w),
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(10.w),
                      color: Color.fromARGB(255, 137, 195, 250),
                      border: Border(
                          // top: BorderSide(color: Colors.black, width: 1.w),
                          // left: BorderSide(color: Colors.black, width: 1.w),
                          // right: BorderSide(
                          //     color: Color.fromARGB(255, 137, 195, 250)),
                          // bottom: BorderSide(
                          //     color: 1 <= widget.currentIndex
                          //         ? const Color.fromARGB(255, 81, 185, 67)
                          //         : Colors.black,
                          //     width: 1.w)
                          )),
                  child: Text(
                    "自检",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: 0 <= widget.currentIndex
                            ? const Color.fromARGB(255, 81, 185, 67)
                            : Color.fromARGB(255, 255, 255, 255)),
                  )),
              Container(
                // width: 40.w,
                height: 50.w,
                margin: const EdgeInsets.only(right: 0),
                decoration: BoxDecoration(
                  border: Border(
                    // 四个值 top right bottom left
                    left: BorderSide(
                        color: const Color.fromARGB(255, 137, 195, 250),
                        width: 25.w,
                        style: BorderStyle.solid),
                    bottom: BorderSide(
                        color: Colors.transparent,
                        width: 25.w,
                        style: BorderStyle.solid),
                    top: BorderSide(
                        color: Colors.transparent,
                        width: 25.w,
                        style: BorderStyle.solid),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ClipPath(
                clipper: ClipperPath(),
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.only(
                        top: 10.w, bottom: 10.w, left: 30.w, right: 30.w),
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(10.w),
                        color: Color.fromARGB(255, 137, 195, 250),
                        border: Border(
                          // top: BorderSide(color: Colors.black, width: 1.w),
                          // left: BorderSide(color: Colors.black, width: 1.w),
                          right: BorderSide(
                              color: Color.fromARGB(255, 137, 195, 250)),
                          // bottom: BorderSide(
                          //     color: 1 <= widget.currentIndex
                          //         ? const Color.fromARGB(255, 81, 185, 67)
                          //         : Colors.black,
                          //     width: 1.w)
                        )),
                    child: Text(
                      "   搜索",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: 1 <= widget.currentIndex
                              ? const Color.fromARGB(255, 81, 185, 67)
                              : Color.fromARGB(255, 255, 255, 255)),
                    )),
              ),
              Container(
                // width: 40.w,
                height: 46.w,
                margin: const EdgeInsets.only(right: 0),
                decoration: BoxDecoration(
                  border: Border(
                    // 四个值 top right bottom left
                    left: BorderSide(
                        color: const Color.fromARGB(255, 137, 195, 250),
                        width: 20.w,
                        style: BorderStyle.solid),
                    bottom: BorderSide(
                        color: Colors.transparent,
                        width: 20.w,
                        style: BorderStyle.solid),
                    top: BorderSide(
                        color: Colors.transparent,
                        width: 20.w,
                        style: BorderStyle.solid),
                  ),
                ),
              ),
            ],
          ),
          ClipPath(
            clipper: ClipperPath(),
            child: Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(
                    top: 10.w, bottom: 10.w, left: 30.w, right: 30.w),
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(10.w),
                    color: Color.fromARGB(255, 137, 195, 250),
                    border: Border(
                      // top: BorderSide(color: Colors.black, width: 1.w),
                      // left: BorderSide(color: Colors.black, width: 1.w),
                      right:
                          BorderSide(color: Color.fromARGB(255, 137, 195, 250)),
                      // bottom: BorderSide(
                      //     color: 1 <= widget.currentIndex
                      //         ? const Color.fromARGB(255, 81, 185, 67)
                      //         : Colors.black,
                      //     width: 1.w)
                    )),
                child: Text(
                  "   完成",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: 2 <= widget.currentIndex
                          ? const Color.fromARGB(255, 81, 185, 67)
                          : Color.fromARGB(255, 255, 255, 255)),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Container(
              //     clipBehavior: Clip.hardEdge,
              //     padding: EdgeInsets.all(10.w),
              //     decoration: BoxDecoration(
              //         // borderRadius: BorderRadius.circular(10.w),
              //         color: const Color(0xffEEEFF2),
              //         border: Border(
              //             top: BorderSide(color: Colors.black, width: 1.w),
              //             left: BorderSide(color: Colors.black, width: 1.w),
              //             right: BorderSide(color: Colors.black, width: 1.w),
              //             bottom: BorderSide(
              //                 color: index <= widget.currentIndex
              //                     ? const Color.fromARGB(255, 81, 185, 67)
              //                     : Colors.black,
              //                 width: 1.w))),
              //     child: Text(
              //       _items[index],
              //       style: TextStyle(
              //           fontSize: 20.sp,
              //           color: index <= widget.currentIndex
              //               ? const Color.fromARGB(255, 81, 185, 67)
              //               : const Color.fromARGB(255, 85, 85, 85)),
              //     )),
              Opacity(
                opacity: index == 0 ? 0 : 1,
                child: Container(
                  width: 80.w,
                  height: 1,
                  decoration: BoxDecoration(
                      color: index <= widget.currentIndex
                          ? const Color.fromARGB(255, 81, 185, 67)
                          : const Color.fromARGB(255, 179, 179, 179)),
                ),
              ),
              Icon(
                Icons.check_circle_outline_outlined,
                color: index <= widget.currentIndex
                    ? const Color.fromARGB(255, 81, 185, 67)
                    : const Color.fromARGB(255, 179, 179, 179),
                size: 32.w,
              ),
              // Image.asset(
              //   index <= widget.currentIndex
              //       ? Constants.getAssetsImage("ic_oval_red")
              //       : Constants.getAssetsImage("ic_oval_gray"),
              //   width: 30.w,
              //   height: 30.w,
              // ),
              Opacity(
                opacity: _items.length - 1 == index ? 0 : 1,
                child: Container(
                  width: 80.w,
                  height: 1,
                  decoration: BoxDecoration(
                      color: index < widget.currentIndex
                          ? const Color.fromARGB(255, 81, 185, 67)
                          : const Color.fromARGB(255, 179, 179, 179)),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.w),
            child: Text(
              _items[index],
              style: TextStyle(
                  fontSize: 20.sp,
                  color: index <= widget.currentIndex
                      ? const Color.fromARGB(255, 81, 185, 67)
                      : const Color.fromARGB(255, 179, 179, 179)),
            ),
          )
        ],
      ),
    );
  }
}

/// 创建剪裁路径
class ClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // 连接到距离左上角3/4处
    path.moveTo(0.0, 0.0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(25.w, size.height / 2);
    // path.lineTo(0.0, size.height);
    // 第一个控制点

    // 闭合
    path.close();
    // 返回剪裁路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>
      oldClipper.hashCode != hashCode;
}
