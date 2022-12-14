import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/model/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/string_util.dart';
import '../../core/widget/custom_app_bar.dart';

/// 我的页面
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  /// 用户信息
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    sharedGetData("loginInfo", List).then((data) {
      if (StringUtil.isNotEmpty(data)) {
        List<String> loginInfo = data as List<String>;
        setState(() {
          userModel = UserModel(
              deptId: '11111',
              deptName: '研发部',
              phone: '13258965478',
              email: '852369745@qq.com');
          userModel.nickName = loginInfo[2];
          userModel.avatar = loginInfo[3];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          title: '我的',
          backgroundColor: const Color.fromRGBO(91, 149, 255, 0.9),
          titleColor: Colors.white,
          borderBottom: false),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 头部
            topWidget(),
            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// 扫一扫
                      scanCode(),

                      /// 账号安全
                      accountSecurity(),

                      /// 清除缓存
                      clearCache(),

                      /// 关于我们
                      aboutUs(),

                      /// 联系客服
                      contactCustomer(),

                      /// 系统设置
                      systemSettings(),

                      /// 图表统计
                      chartCal(),

                      /// 文件上传与下载
                      fileUplodAndDownload(),

                      const Divider(),

                      /// 设备信息
                      commonProblem(),

                      const Divider(),

                      /// WAN设置
                      wanSettings(),

                      /// DNS设置
                      dnsSettings(),

                      /// Radio设置
                      radioSettings(),

                      /// PIN码管理
                      pinSettings(),

                      /// LAN设置
                      lanSettings(),

                      /// 静态路由
                      staticRoute(),

                      /// 无线开关
                      wirelessSwitch(),
                      const Divider(),

                      /// 以太网状态
                      feedback(),

                      ///以太网设置
                      netSet(),
                      const Divider(),

                      /// WLAN设置
                      wlanSet(),

                      /// 访客网络
                      visitorNet(),

                      /// 专业设置
                      majorSet(),

                      /// WPS设置
                      wpsSet(),
                      const Divider(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  /// 头部
  Widget topWidget() {
    return Container(
      height: 230.w,
      decoration: const BoxDecoration(color: Color.fromRGBO(91, 149, 255, 0.9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 头像 + 名字
          InkWell(
            onTap: () {
              Get.toNamed("/user_detail", arguments: userModel);
            },
            child: Container(
              height: 100.w,
              padding: EdgeInsets.only(left: 20.w),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: -25.w, right: -25.w),
                leading: CommonWidget.imageWidget(
                    imageUrl: userModel.avatar, hasDefault: true),
                title: Text(
                  userModel.nickName ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
                ),
              ),
            ),
          ),
          SizedBox(
              height: 130.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: '9,999',
                            style:
                                TextStyle(color: Colors.white, fontSize: 35.sp),
                            children: [
                              TextSpan(
                                text: ' 元',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.sp),
                              ),
                            ]),
                      ),
                      const Text(
                        '余额',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.currency_yen_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '充值',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.bookmark_border_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '余额明细',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  /// 扫一扫
  Widget scanCode() {
    return CommonWidget.simpleWidgetWithMine(
        title: '扫一扫',
        icon: const Icon(Icons.crop_free_outlined,
            color: Color.fromRGBO(88, 202, 147, 1)),
        callBack: () {
          Get.toNamed("/scan_code")?.then((value) => {
                ToastUtils.toast("扫描的信息：$value"),
              });
        });
  }

  /// 设备信息
  Widget commonProblem() {
    return CommonWidget.simpleWidgetWithMine(
        title: '设备信息',
        icon: const Icon(Icons.report_gmailerrorred_outlined,
            color: Color.fromRGBO(255, 148, 6, 1)),
        callBack: () {
          Get.toNamed("/common_problem");
        });
  }

  /// 以太网状态
  Widget feedback() {
    return CommonWidget.simpleWidgetWithMine(
        title: '以太网状态',
        icon: const Icon(Icons.share_location,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/feed_back");
        });
  }

  /// 账号安全
  Widget accountSecurity() {
    return CommonWidget.simpleWidgetWithMine(
        title: '账号安全',
        icon: const Icon(Icons.security_outlined,
            color: Color.fromRGBO(49, 110, 222, 1)),
        callBack: () {
          /// 子页面带返回值的
          Get.toNamed("/account_security")
              ?.then((value) => {print("新密码：$value")});
        });
  }

  /// 清除缓存
  Widget clearCache() {
    return CommonWidget.simpleWidgetWithMine(
        title: '清除缓存',
        icon: const Icon(Icons.cached_outlined,
            color: Color.fromRGBO(89, 189, 249, 1)),
        callBack: () {
          Get.toNamed("/clear_cache");
        });
  }

  /// 关于我们
  Widget aboutUs() {
    return CommonWidget.simpleWidgetWithMine(
        title: '关于我们',
        icon: const Icon(Icons.person_outline_outlined,
            color: Color.fromRGBO(39, 192, 220, 1)),
        callBack: () {
          Get.toNamed("/about_us");
        });
  }

  /// 联系客服
  Widget contactCustomer() {
    return CommonWidget.simpleWidgetWithMine(
        title: '联系客服',
        icon: const Icon(Icons.connect_without_contact_outlined,
            color: Color.fromRGBO(255, 138, 0, 1)),
        callBack: () {
          Get.toNamed("/contact_customer");
        });
  }

  /// 系统设置
  Widget systemSettings() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: '系统设置',
          icon: const Icon(Icons.settings,
              color: Color.fromRGBO(39, 103, 220, 1)),
          callBack: () {
            Get.toNamed("/system_settings");
          }),
    );
  }

  /// 图表
  Widget chartCal() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: '图表统计',
          icon: const Icon(Icons.table_chart_outlined,
              color: Color.fromRGBO(79, 203, 116, 1)),
          callBack: () {
            Get.toNamed("/chart_demo");
          }),
    );
  }

  /// 文件上传下载测试
  Widget fileUplodAndDownload() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: '文件上传与下载',
          icon: const Icon(Icons.cloud_sync_outlined,
              color: Color.fromRGBO(242, 100, 124, 1)),
          callBack: () {
            Get.toNamed("/file_upload_download");
          }),
    );
  }

  /// 网络设置
  Widget networkSettings() {
    // return CommonWidget.simpleWidgetWithUserDetail("头像",
    //     value: userModel.avatar, isImage: true, callBack: () {
    //   print("更换头像");
    // });

    return Container(
        padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
        height: 50,
        width: 200,
        decoration: const BoxDecoration(color: Colors.white),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CommonWidget.simpleWidgetWithMine(
              title: '网络设置',
              icon: const Icon(Icons.settings_applications_outlined,
                  color: Color.fromRGBO(255, 148, 6, 1)),
              callBack: () {
                Get.toNamed("/network_settings");
              }),
          const Icon(Icons.navigate_next, color: Colors.grey),
        ]));
  }

  /// WAN设置
  Widget wanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WAN设置',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/wan_settings");
        });
  }

  /// DNS设置
  Widget dnsSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'DNS设置',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/dns_settings");
        });
  }

  /// Radio设置
  Widget radioSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'Radio设置',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/radio_settings");
        });
  }

  /// PIN码管理
  Widget pinSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'PIN码管理',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/pin_settings");
        });
  }

  /// LAN设置
  Widget lanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'LAN设置',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/lan_settings");
        });
  }

  /// 静态路由
  Widget staticRoute() {
    return CommonWidget.simpleWidgetWithMine(
        title: '静态路由',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/static_route");
        });
  }

  /// 无线开关
  Widget wirelessSwitch() {
    return CommonWidget.simpleWidgetWithMine(
        title: '无线开关',
        icon: const Icon(Icons.headset_mic_outlined,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/wireless_switch");
        });
  }

  /// 以太网设置
  Widget netSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '以太网设置',
        icon: const Icon(Icons.share_location,
            color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/net_set");
        });
  }

  /// WLAN设置
  Widget wlanSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WLAN设置',
        icon: const Icon(Icons.wifi, color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/wlan_set");
        });
  }

  /// 访客网络
  Widget visitorNet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '访客网络',
        icon: const Icon(Icons.wifi, color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/visitor_net");
        });
  }

  /// 专业设置
  Widget majorSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '专业设置',
        icon: const Icon(Icons.wifi, color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/major_set");
        });
  }

  /// WPS设置
  Widget wpsSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WPS设置',
        icon: const Icon(Icons.wifi, color: Color.fromRGBO(95, 154, 255, 1)),
        callBack: () {
          Get.toNamed("/wps_set");
        });
  }
}
