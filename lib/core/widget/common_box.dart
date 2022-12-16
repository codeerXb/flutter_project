import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//底部线
class BottomLine extends StatelessWidget {
  final Widget rowtem;

  const BottomLine({super.key, required this.rowtem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.w,
      padding:  EdgeInsets.only(bottom: 6.w),
      margin:  EdgeInsets.only(bottom: 6.w),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: rowtem,
    );
  }
}

//信息每行
class RowContainer extends StatelessWidget {
  final String leftText;
  final String righText;

  const RowContainer(
      {super.key, required this.leftText, required this.righText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leftText,
            style:  TextStyle(
                color:const Color.fromARGB(255, 5, 0, 0), fontSize: 28.sp)),
        Text(
          righText,
          style:  TextStyle(
              color:const Color.fromARGB(255, 37, 37, 36), fontSize: 26.sp),
        ),
      ],
    );
  }
}

//标题
class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.only(bottom: 10.0.w),
      child: Text(
        title,
        style:  TextStyle(color: Colors.black, fontSize: 30.sp),
      ),
    );
  }
}

//信息盒子
class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:  EdgeInsets.all(28.0.w),
        margin:  EdgeInsets.only(bottom: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: boxCotainer);
  }
}
