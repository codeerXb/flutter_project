import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 常量类
class Constant {

  /// toast 提示默认时长
  static const defaultToastDuration = Duration(seconds: 2);
  /// toast 提示默认颜色
  static const defaultToastColor = Color(0xFF424242);

  static double defaultWidth = 750.w;

  /// 搜索框相关样式 开始
  static const searchDecorationColor = Color.fromRGBO(240, 240, 240, 1);

  static TextStyle searchTextFiledStyle = TextStyle(
    fontSize: 26.sp,
    color: const Color(0xff051220)
  );

  static TextStyle searchTextFieldHintStyle = TextStyle(
    fontSize: 26.sp,
    color: const Color(0xff979DA3)
  );
  /// 搜索框相关样式 结束

  /// 主页面 左右侧padding值
  static double paddingLeftRight = 20.w;

  /// 默认用户联系人头像-共用配置(通讯录默认头像)
  static const defaultUserAvatar = "assets/images/default_avatar.png";
  /// 个人微信
  static const wxGenRen = "assets/images/weixin_geren.png";
  /// 公众号微信
  static const wxGongZhongHao = "assets/images/weixin_gongzhonghao.png";

  static const Color colorGrey = Color.fromRGBO(144, 147, 153, 1);

}
