import 'package:flutter/material.dart';
import 'package:flutter_template/pages/Ethernet/net/net_set.dart';
import 'package:flutter_template/pages/get_test/index.dart';
import 'package:flutter_template/pages/get_equipment/index.dart';
import 'package:flutter_template/pages/netMode/netMode.dart';
import 'package:flutter_template/pages/net_status/connect_device/index.dart';
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
import 'package:flutter_template/pages/Ethernet/net_type.dart';
import 'package:flutter_template/pages/setting/language_change.dart';
import 'package:flutter_template/pages/setting/user_detail.dart';
import 'package:flutter_template/pages/signal_cover/detection_edit.dart';
import 'package:flutter_template/pages/sub_service/ai_video.dart';
import 'package:flutter_template/pages/sub_service/game_acceleration.dart';
import 'package:flutter_template/pages/sub_service/index.dart';
import 'package:flutter_template/pages/sub_service/parental_control.dart';
import 'package:flutter_template/pages/user_login/forgetPassword.dart';
import 'package:flutter_template/pages/user_login/login.dart';
import 'package:flutter_template/pages/user_login/register.dart';
// import 'package:flutter_template/pages/video/index.dart';
// import 'package:flutter_template/pages/video/show_img.dart';
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
import 'package:flutter_template/pages/login/login.dart';
import 'package:flutter_template/pages/login/user_agreement.dart';
import 'package:flutter_template/pages/network_settings/dns_settings.dart';
import 'package:flutter_template/pages/network_settings/lan_settings.dart';
import 'package:flutter_template/pages/network_settings/radio_settings.dart';
import 'package:flutter_template/pages/network_settings/wan_settings.dart';
import 'package:flutter_template/pages/parent_control/card_list/shopping.dart';
import 'package:flutter_template/pages/parent_control/card_list/Social.dart';
import 'package:flutter_template/pages/parent_control/card_list/Video.dart';
import 'package:flutter_template/pages/setting/chart_demo.dart';
import 'package:flutter_template/pages/setting/system_settings.dart';
import 'package:flutter_template/pages/system_settings/maintain_settings.dart';
import 'package:flutter_template/pages/system_settings/account_security.dart';
import 'package:flutter_template/pages/toolbar/index.dart';
import 'package:flutter_template/pages/topo/parental/parental_control.dart';
import 'package:flutter_template/pages/topo/parental/parental_pop.dart';
import 'package:flutter_template/pages/topo/parental/parental_update.dart';
import 'package:flutter_template/pages/add_equipment/index.dart';
import 'package:flutter_template/pages/signal_cover/index.dart';
// import 'package:flutter_template/pages/signal_cover/index1.dart';
import 'package:flutter_template/pages/signal_cover/SignalCoverage.dart';
import 'package:flutter_template/pages/user_login/changePasswordPage.dart';
import 'package:flutter_template/pages/user_login/user_location.dart';
import "package:flutter_template/pages/get_equipment/unnetworkpage.dart";
import 'package:flutter_template/pages/setting/user_personal_information.dart';
import 'package:flutter_template/pages/Ethernet/net/wan_status.dart';
// import 'package:get/get.dart';
import '../webscoket/scoket_service.dart';
import '../../pages/net_status/channel_scan.dart';
import '../../pages/net_status/channel_tables.dart';
import '../../pages/net_status/channel_tables_advance.dart';
import '../../pages/parent_control/pie_chart_page.dart';
import '../../pages/parent_control/parent_detail_page.dart';
import '../../pages/parent_control/parent_config_page.dart';
import '../../pages/parent_control/parent_config_home.dart';
import '../../pages/parent_control/website_creat_page.dart';
import '../../pages/parent_control/parent_device_page.dart';
import '../../pages/parent_control/parent_time_list_page.dart';
import '../../pages/parent_control/parent_creatTimPage.dart';
import '../../pages/net_status/speed_test_page.dart';
import '../../pages/net_status/lan_speed_test_page.dart';
import '../../pages/user_login/privacy_page.dart';
import '../../pages/parent_control/parent_device_timeList.dart';
import '../../pages/setting/company_website_page.dart';
import 'package:flutter_template/pages/setting/logout_account.dart';
import '../../pages/net_status/home_speed_test.dart';
import 'package:flutter_template/pages/setting/router_version_upgrade.dart';
import '../../pages/setting/access_control.dart';
import '../../pages/setting/access_blacklist_set.dart';
import '../../pages/setting/access_control_devices.dart';
import '../../pages/setting/edit_access_control_devices.dart';
/// 路由
class GlobalRouter {
  // 定义单例
  static GlobalRouter? _singleton;

  GlobalRouter._internal();

  factory GlobalRouter() {
    return _singleton ?? GlobalRouter._internal();
  }

  // -------------------------------------------------路由-------------------------------------------------------
  /// 从非toolbar页面（子页面）跳转到toolbar页面（主页）实现：
  /// pushName到对应的路由，因为Toolbar是单例模式，所以只会创建一个
  /// pushName之后，在ToolBar，initState中获取当前的路由，实现切换页面
  static final _routes = {
    /// 选择上网方式
    '/NetMode': (BuildContext context, {Object? args}) => const NetMode(),

    /// 过渡页面
    '/': (BuildContext context, {Object? args}) => const SplashPage(),

    /// 搜索设备
    '/get_equipment': (BuildContext context, {Object? args}) =>
        const Equipment(),

    /// 主页面
    '/home': (BuildContext context, {Object? args}) => const Toolbar(),

    /// 设备登录
    '/loginPage': (BuildContext context, {Object? args}) => const Login(),

    /// 个人中心
    "/Personal_Center": (BuildContext context, {Object? args}) => const
        UserPersonalInformation(),

    /// 用户协议页面
    '/user_agreement': (BuildContext context, {Object? args}) =>
        const UserAgreement(),

    /// 用户详情
    '/user_detail': (BuildContext context, {Object? args}) =>
        const UserDetail(),

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

    /// 套餐设置
    '/net_server_settings': (BuildContext context, {Object? args}) =>
        const NetServerSettings(),

    /// 用户登录（云平台登录）
    '/user_login': (BuildContext context, {Object? args}) => const UserLogin(),

    /// 用户注册（云平台注册）
    '/user_register': (BuildContext context, {Object? args}) =>
        const UserRegister(),

    /// 忘记密码
    '/forget_password': (BuildContext context, {Object? args}) =>
        const ForgetPassword(),

    /// 修改密码
    '/change_password': (BuildContext context, {Object? args}) =>
        const ChangePasswordPage(),

    /// 接入设备
    '/connected_device': (BuildContext context, {Object? args}) =>
        const ConnectedDevice(),
    // // 视频
    // '/video_play': (BuildContext context, {Object? args}) => const VideoPlay(),
    // // 图片
    // '/img': (BuildContext context, {Object? args}) => const SwiperPage(),
    /// 家长控制
    '/parental_control': (BuildContext context, {Object? args}) =>
        const ParentalControl(),

    /// 家长控制 新增
    '/parental_pop': (BuildContext context, {Object? args}) =>
        const ParentalPop(),

    /// 家长控制 修改
    '/parental_update': (BuildContext context, {Object? args}) =>
        const ParentalUpdate(),

    /// 订阅服务
    '/sub_service': (BuildContext context, {Object? args}) =>
        const SubSerivce(),

    /// 家长控制详情
    '/parcontrol_info': (BuildContext context, {Object? args}) =>
        const Parcontrol(),

    /// 游戏加速详情
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
    '/Installed': (BuildContext context, {Object? args}) => const Installed(),
    // 家长控制_Blocklist
    '/Blocklist': (BuildContext context, {Object? args}) => const Blocklist(),
    // 家长控制_Internet
    '/Internet': (BuildContext context, {Object? args}) => const Internet(),
    // 家长控制_Internetaccess
    '/Internetaccess': (BuildContext context, {Object? args}) =>
        const Internetaccess(),
    // 更改语言
    '/language_change': (BuildContext context, {Object? args}) =>
        const LanguageChange(),
    // 网络测试
    '/get_test': (BuildContext context, {Object? args}) =>
        GlobalNetworkDialog(),
    // 添加设备
    '/add_equipment': (BuildContext context, {Object? args}) =>
        const AddEquipment(),
    // 房间户型检测与编辑(1)
    '/test_edit': (BuildContext context, {Object? args}) => const TestEdit(),
    // 编辑房间户型(2)
    '/signal_cover': (BuildContext context, {Object? args}) => const MyApp(),
    // 测试信号强度(3)
    '/test_signal': (BuildContext context, {Object? args}) =>
        const TestSignal(),
    '/test_location': (BuildContext context, {Object? args}) =>
        const GetUserLocation(title: "title"),
    '/unNetworkpage': (BuildContext context, {Object? args}) =>
        const ConnectionlessPage(),
    // WanStatus
    '/wanStatusPage': (BuildContext context, {Object? args}) =>
        const WanStatusPage(),
    '/socketPage': (BuildContext context, {Object? args}) =>
        const SocketChannelPage(),
    '/channelScan': (BuildContext context, {Object? args}) =>
        const ChannelScanPage(),
    '/channelList': (BuildContext context, {Object? args}) =>
        const ChannelListPage(),
    '/advancechannelList': (BuildContext context, {Object? args}) =>
        const AdvanceChannelListPage(),
    '/parentList': (BuildContext context, {Object? args}) =>
        const PieChartPage(),
    '/parentConfigPage': (BuildContext context, {Object? args}) =>
        const ParentConfigPage(),
    '/parentDetailList': (BuildContext context, {Object? args}) =>
        const ParentDetailListPage(),
    '/parentConfigHome': (BuildContext context, {Object? args}) =>
        const ParentConfigHomePage(),
    '/websiteConfigPage': (BuildContext context, {Object? args}) =>
        const ParentWebSitePage(),
    '/websiteDevicePage': (BuildContext context, {Object? args}) =>
        const ParentDevicePage(),
    '/websiteTimeListPage': (BuildContext context, {Object? args}) =>
        const ParentTimeListPage(),
    '/websiteCreatTimePage': (BuildContext context, {Object? args}) =>
        const ParentCreatTimePage(),
    '/speedTestPage': (BuildContext context, {Object? args}) =>
        const SpeedTestHomeVC(),
    '/lanSpeedTestPage': (BuildContext context, {Object? args}) =>
        const HomeSpeedPage(),
    '/privacyPage': (BuildContext context, {Object? args}) =>
        const PrivacyPage(),
    '/timeConfigPage': (BuildContext context, {Object? args}) =>
        const TimeConfigListPage(),
    '/commpanyWebsitePage': (BuildContext context, {Object? args}) =>
        const CompanyWebsitePage(),
    '/delAccountPage': (BuildContext context, {Object? args}) =>
        const DelAccountPage(),
    '/routerUpgradePage': (BuildContext context, {Object? args}) =>
        const RouterUpgradePage(),
    '/access_control': (BuildContext context, {Object? args}) =>
        const AccessController(),
    '/access_blacklist': (BuildContext context, {Object? args}) =>
        const AccessBlackList(),
    '/access_devices': (BuildContext context, {Object? args}) =>
        const AccessControlDevicesPage(),
    '/edit_access_devices': (BuildContext context, {Object? args}) =>
        const EditAccessBlackList(),
  };

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
