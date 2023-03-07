import 'package:flutter/material.dart';
import 'package:flutter_template/pages/Ethernet/net/net_set.dart';
import 'package:flutter_template/pages/get_equipment/index.dart';
import 'package:flutter_template/pages/odu/index.dart';
import 'package:flutter_template/pages/parent_control/Internet_access/index.dart';
import 'package:flutter_template/pages/parent_control/Internet_usage/index.dart';
import 'package:flutter_template/pages/parent_control/card_list/Blocklist.dart';
import 'package:flutter_template/pages/parent_control/card_list/Games.dart';
import 'package:flutter_template/pages/parent_control/card_list/Installed.dart';
import 'package:flutter_template/pages/parent_control/index.dart';
import 'package:flutter_template/pages/setting/about_us.dart';
import 'package:flutter_template/pages/setting/clear_cache.dart';
import 'package:flutter_template/pages/equInfo/equ_info.dart';
import 'package:flutter_template/pages/setting/contact_customer.dart';
import 'package:flutter_template/pages/setting/file_upload_download.dart';
import 'package:flutter_template/pages/Ethernet/net_type.dart';
import 'package:flutter_template/pages/setting/user_detail.dart';
import 'package:flutter_template/pages/sub_service/ai_video.dart';
import 'package:flutter_template/pages/sub_service/game_acceleration.dart';
import 'package:flutter_template/pages/sub_service/index.dart';
import 'package:flutter_template/pages/sub_service/parental_control.dart';
import 'package:flutter_template/pages/user_login/forgetPassword.dart';
import 'package:flutter_template/pages/user_login/login.dart';
import 'package:flutter_template/pages/user_login/register.dart';
import 'package:flutter_template/pages/video/index.dart';
import 'package:flutter_template/pages/video/show_img.dart';
import 'package:flutter_template/pages/vidicon/index.dart';
import 'package:flutter_template/pages/vidicon/look_back.dart';
import 'package:flutter_template/pages/vidicon/look_house.dart';
import 'package:flutter_template/pages/vidicon/storage_administration.dart';
import 'package:flutter_template/pages/wifi_set/major/major_set.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_visitor1.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_visitor2.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_visitor3.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5g_visitor1.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5g_visitor2.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5g_visitor3.dart';
import 'package:flutter_template/pages/wifi_set/visitor/visitor_net.dart';
import 'package:flutter_template/pages/wifi_set/wlan/wlan_set.dart';
import 'package:flutter_template/pages/wifi_set/wps/wps_set.dart';
import 'package:flutter_template/pages/topo/access_equipment.dart';
import 'package:flutter_template/splash.dart';
import 'package:flutter_template/pages/net_status/net_server_settings.dart';

import '../../pages/address_book/address_book_detail.dart';
import '../../pages/login/login.dart';
import '../../pages/login/user_agreement.dart';
import '../../pages/network_settings/dns_settings.dart';
import '../../pages/network_settings/lan_settings.dart';
import '../../pages/network_settings/radio_settings.dart';
import '../../pages/network_settings/wan_settings.dart';
import '../../pages/parent_control/card_list/Payment.dart';
import '../../pages/parent_control/card_list/Social.dart';
import '../../pages/parent_control/card_list/Video.dart';
import '../../pages/setting/chart_demo.dart';
import '../../pages/setting/scan_code.dart';
import '../../pages/setting/system_settings.dart';
import '../../pages/system_settings/maintain_settings.dart';
import '../../pages/system_settings/account_security.dart';
import '../../pages/toolbar/index.dart';
import '../../pages/topo/parental_control.dart';
import '../../pages/topo/parental_pop.dart';
import '../../pages/topo/parental_update.dart';

/// 路由
class GlobalRouter {
  /// 路由
  /// 从非toolbar页面（子页面）跳转到toolbar页面（主页）实现：
  /// pushName到对应的路由，因为Toolbar是单例模式，所以只会创建一个
  /// pushName之后，在ToolBar，initState中获取当前的路由，实现切换页面
  static final _routes = {
    /// 过渡页面
    '/': (BuildContext context, {Object? args}) => const SplashPage(),

    /// 搜索设备
    '/get_equipment': (BuildContext context, {Object? args}) =>
        const Equipment(),

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

    /// LAN设置
    '/lan_settings': (BuildContext context, {Object? args}) =>
        const LanSettings(),

    /// 以太网设置
    '/net_set': (BuildContext context, {Object? args}) => const NetSet(),

    /// WLAN设置
    '/wlan_set': (BuildContext context, {Object? args}) => const WlanSet(),

    /// 访客网络
    '/visitor_net': (BuildContext context, {Object? args}) =>
        const VisitorNet(),
    '/visitor_one': (BuildContext context, {Object? args}) => const Visitor1(),
    '/visitor_two': (BuildContext context, {Object? args}) => const Visitor2(),
    '/visitor_three': (BuildContext context, {Object? args}) =>
        const Visitor3(),
    '/visitor_four': (BuildContext context, {Object? args}) => const Visitor4(),
    '/visitor_five': (BuildContext context, {Object? args}) => const Visitor5(),
    '/visitor_six': (BuildContext context, {Object? args}) => const Visitor6(),

    /// 专业设置
    '/major_set': (BuildContext context, {Object? args}) => const MajorSet(),

    /// WPS设置
    '/wps_set': (BuildContext context, {Object? args}) => const WpsSet(),

    /// 接入设备
    '/access_equipment': (BuildContext context, {Object? args}) =>
        const AccessEquipment(),

    /// 维护设置
    '/maintain_settings': (BuildContext context, {Object? args}) =>
        const MaintainSettings(),

    /// 接入设备
    // '/odu': (BuildContext context, {Object? args}) => const SocketPage(),
    '/odu': (BuildContext context, {Object? args}) => const ODU(),

    // 套餐设置
    '/net_server_settings': (BuildContext context, {Object? args}) =>
        const NetServerSettings(),

    // 用户登录
    '/user_login': (BuildContext context, {Object? args}) => const UserLogin(),

    // 用户注册
    '/user_register': (BuildContext context, {Object? args}) =>
        const UserRegister(),
    // 忘记密码
    '/forget_password': (BuildContext context, {Object? args}) =>
        const ForgetPassword(),

    // 视频
    '/video_play': (BuildContext context, {Object? args}) => const VideoPlay(),
    // 图片
    '/img': (BuildContext context, {Object? args}) => const SwiperPage(),
    // 家长控制
    '/parental_control': (BuildContext context, {Object? args}) =>
        const ParentalControl(),
    // 家长控制 新增
    '/parental_pop': (BuildContext context, {Object? args}) =>
        const ParentalPop(),
    // 家长控制 修改
    '/parental_update': (BuildContext context, {Object? args}) =>
        const ParentalUpdate(),
    // 订阅服务
    '/sub_service': (BuildContext context, {Object? args}) =>
        const SubSerivce(),
    // 家长控制详情
    '/parcontrol_info': (BuildContext context, {Object? args}) =>
        const Parcontrol(),
    // 游戏加速详情
    '/gameacce_inofo': (BuildContext context, {Object? args}) =>
        const Gameacce(),
    // ai视频
    '/ai_video': (BuildContext context, {Object? args}) => const Aivideo(),
    // 摄像机
    '/vidicon': (BuildContext context, {Object? args}) => const Vidicon(),
    // 回看
    '/look_back': (BuildContext context, {Object? args}) => const LookBack(),
    // 看家
    '/look_house': (BuildContext context, {Object? args}) => const LookHouse(),
    // 存储管理
    '/storage_administration': (BuildContext context, {Object? args}) =>
        const AtorageAdministration(),
    // 首页_家长控制
    '/parent': (BuildContext context, {Object? args}) => const Parent(),
    // 家长控制_game
    '/games': (BuildContext context, {Object? args}) => const Games(),
    // 家长控制_video
    '/Video': (BuildContext context, {Object? args}) => const Video(),
    // 家长控制_Social
    '/Social': (BuildContext context, {Object? args}) => const Social(),
    // 家长控制_Payment
    '/Payment': (BuildContext context, {Object? args}) => const Payment(),
    // 家长控制_Installed
    '/Installed': (BuildContext context, {Object? args}) => const Intsalled(),
    // 家长控制_Blocklist
    '/Blocklist': (BuildContext context, {Object? args}) => const Blocklist(),
    // 家长控制_Internet
    '/Internet': (BuildContext context, {Object? args}) => const Internet(),
    // 家长控制_Internetaccess
    '/Internetaccess': (BuildContext context, {Object? args}) =>
        const Internetaccess(),
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
