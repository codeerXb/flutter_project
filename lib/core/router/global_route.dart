import 'package:flutter/material.dart';
import 'package:flutter_template/pages/setting/about_us.dart';
import 'package:flutter_template/pages/setting/clear_cache.dart';
import 'package:flutter_template/pages/setting/equ_info.dart';
import 'package:flutter_template/pages/setting/contact_customer.dart';
import 'package:flutter_template/pages/setting/file_upload_download.dart';
import 'package:flutter_template/pages/setting/net_set.dart';
import 'package:flutter_template/pages/setting/net_type.dart';
import 'package:flutter_template/pages/setting/user_detail.dart';
import 'package:flutter_template/pages/topo/access_equipment.dart';
import 'package:flutter_template/splash.dart';

import '../../pages/address_book/address_book_detail.dart';
import '../../pages/login/login.dart';
import '../../pages/login/user_agreement.dart';
import '../../pages/setting/account_security.dart';
import '../../pages/setting/chart_demo.dart';
import '../../pages/setting/scan_code.dart';
import '../../pages/setting/system_settings.dart';
import '../../pages/toolbar.dart';
import '../../pages/setting/wan_settings.dart';
import '../../pages/setting/dns_settings.dart';
import '../../pages/setting/radio_settings.dart';
import '../../pages/setting/pin_settings.dart';
import '../../pages/setting/lan_settings.dart';
import '../../pages/setting/static_route.dart';
import '../../pages/setting/wireless_switch.dart';

/// 路由
class GlobalRouter {
  /// 路由
  /// 从非toolbar页面（子页面）跳转到toolbar页面（主页）实现：
  /// pushName到对应的路由，因为Toolbar是单例模式，所以只会创建一个
  /// pushName之后，在ToolBar，initState中获取当前的路由，实现切换页面
  static final _routes = {
    /// 过渡页面
    '/': (BuildContext context, {Object? args}) => const SplashPage(),

    /// 主页面
    '/home': (BuildContext context, {Object? args}) => const Toolbar(),

    /// 登录页面
    '/loginPage': (BuildContext context, {Object? args}) => const Login(),

    /// 用户协议页面
    '/user_agreement': (BuildContext context, {Object? args}) =>
        const UserAgreement(),

    /// 用户详情
    '/user_detail': (BuildContext context, {Object? args}) =>
        const UserDetail(),

    /// 扫一扫
    '/scan_code': (BuildContext context, {Object? args}) => const ScanCode(),

    /// 设备信息
    '/common_problem': (BuildContext context, {Object? args}) =>
        const EquInfo(),

    /// 以太网
    '/feed_back': (BuildContext context, {Object? args}) => const NetType(),

    /// 修改密码
    '/account_security': (BuildContext context, {Object? args}) =>
        const AccountSecurity(),

    /// 清除缓存
    '/clear_cache': (BuildContext context, {Object? args}) =>
        const ClearCache(),

    /// 关于我们
    '/about_us': (BuildContext context, {Object? args}) => const AboutUs(),

    /// 联系客服
    '/contact_customer': (BuildContext context, {Object? args}) =>
        const ContactCustomer(),

    /// 系统设置
    '/system_settings': (BuildContext context, {Object? args}) =>
        const SystemSettings(),

    /// 图表demo
    '/chart_demo': (BuildContext context, {Object? args}) => const ChartDemo(),

    /// 文件上传与下载
    '/file_upload_download': (BuildContext context, {Object? args}) =>
        const FileUploadDownload(),

    ///通讯录详情
    '/address_book_detail': (BuildContext context, {Object? args}) =>
        const AddressBookDetail(),

    /// WAN设置
    '/wan_settings': (BuildContext context, {Object? args}) =>
        const WanSettings(),

    /// DNS设置
    '/dns_settings': (BuildContext context, {Object? args}) =>
        const DnsSettings(),

    /// Radio设置
    '/radio_settings': (BuildContext context, {Object? args}) =>
        const RadioSettings(),

    /// PIN码管理
    '/pin_settings': (BuildContext context, {Object? args}) =>
        const PinSettings(),

    /// LAN设置
    '/lan_settings': (BuildContext context, {Object? args}) =>
        const LanSettings(),

    /// 静态路由
    '/static_route': (BuildContext context, {Object? args}) =>
        const StaticRoute(),

    /// 无线开关
    '/wireless_switch': (BuildContext context, {Object? args}) =>
        const WirelessSwitch(),

    /// 以太网设置
    '/net_set': (BuildContext context, {Object? args}) => const NetSet(),

    /// 接入设备
    '/access_equipment': (BuildContext context, {Object? args}) =>
        const AccessEquipment(),
  };

  static GlobalRouter? _singleton;

  GlobalRouter._internal();

  factory GlobalRouter() {
    return _singleton ?? GlobalRouter._internal();
  }

  /// 监听route
  Route? getRoutes(RouteSettings settings) {
    String? routeName = settings.name;
    final Function builder = GlobalRouter._routes[routeName] as Function;
    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) =>
            builder(context, args: settings.arguments));
  }
}
