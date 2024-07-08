import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:get/get.dart';

/// 通用appbar
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// @param {List<Widget>} actions - 右侧action功能
/// @param {Object?} result - 左键跳转携带参数
AppBar customAppbar(
    {BuildContext? context,
    String title = '',
    bool borderBottom = true,
    List<Widget>? actions,
    Color titleColor = const Color.fromRGBO(76, 76, 76, 1),
    Color backgroundColor = Colors.white,
    dynamic result}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: titleColor, fontSize: 20,fontWeight:FontWeight.bold),
      textScaler: TextScaler.noScaling,
    ),
    backgroundColor: backgroundColor,
    elevation: 0,
    leading: context == null
        ? Container()
        : InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: titleColor,
              size: 16,
            ),
            onTap: () => Get.back(result: result),
          ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Container(
        decoration: BoxDecoration(
            border: CommonWidget.borderBottom(show: borderBottom)),
      ),
    ),
    actions: actions,
  );
}
