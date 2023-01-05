import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @Author: tzh
///
/// @CreateDate: 2021/8/30 11:46
///
/// @Description: 自定义步骤条
///

class StepsWidget extends StatefulWidget {
  const StepsWidget({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  _StepsWidgetState createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  var _items = ["复位", "搜索", "完成"];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: 100.h,
      alignment: Alignment.center,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            //如果显示到最后一个并且Icon总数小于200时继续获取数据
            return _buildItem(index);
          }),
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
            padding: EdgeInsets.only(top: 5.h),
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
