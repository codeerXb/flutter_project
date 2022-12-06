import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../config/constant.dart';

/// 提示
class ToastUtils {
  ToastUtils._internal();

  ///全局初始化Toast配置, child为MaterialApp
  static init(Widget child) {
    return OKToast(
      ///字体大小
      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
      backgroundColor: Constant.defaultToastColor,
      radius: 10,
      dismissOtherOnShow: true,
      textPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      duration: Constant.defaultToastDuration,
      child: child,
    );
  }

  /// 普通弹框
  static void toast(String msg,
      {Duration duration = Constant.defaultToastDuration,
      Color color = Constant.defaultToastColor}) {
    showToast(msg, duration: duration, backgroundColor: color);
  }

  /// 警告弹框
  static void waring(String msg, {Duration duration = Constant.defaultToastDuration}) {
    showToast(msg, duration: duration, backgroundColor: Colors.yellow);
  }

  /// 错误弹框
  static void error(String msg, {Duration duration = Constant.defaultToastDuration}) {
    showToast(msg, duration: duration, backgroundColor: Colors.red);
  }

  /// 成功弹框
  static void success(String msg,
      {Duration duration = Constant.defaultToastDuration}) {
    showToast(msg, duration: duration, backgroundColor: Colors.lightGreen);
  }

  /// 对话框弹框:
  /// context:   上下文
  /// contentDetail:   对话框展示内容
  /// leftBtnText:   左边按钮文字
  /// rightBtnText: 右边按钮文字
  /// successCallback:  确定回调
  /// cancelCallback:  取消回调
  static void showDialogPopup(BuildContext context, String contentDetail, {String title = "提示", String leftBtnText = "取消", String rightBtnText = "确定", Function? successCallback, Function? cancelCallback}){
    showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(title),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 20.w),
            child: Text(contentDetail),
          ),
          actions: [
            TextButton(
              child: Text(leftBtnText, style: const TextStyle(color: Colors.grey),),
              onPressed: () {
                Get.back();
                cancelCallback == null ? print("没有传递回调函数") : cancelCallback();
              },
            ),
            TextButton(
              child: Text(rightBtnText),
              onPressed: () {
                Get.back();
                successCallback == null ? print("没有传递回调函数") : successCallback();
              },
            ),
          ],
        );
      }
    );
  }

  /// 加载框 关闭调用dismissAllToast()
  static void showLoading({String msg = "加载中...", Color backgroundColor = const Color(0xff000000), Color fontColor = const Color(0xffffffff), Duration duration = const Duration(seconds: 30)}){
    showToastWidget(Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0),),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(fontColor)),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,),
                  child: Text(msg, style: TextStyle(color: fontColor),),
                ),
              ],
            ),
          ),
        ),
      ),
    ), duration: duration);
  }

}
