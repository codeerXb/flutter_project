import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/model/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/setting/user_card.dart';
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
  final LoginController loginController = Get.put(LoginController());

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
          title: '高级设置',
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
            UserCard(
              name: loginController.equipment['systemVersionSn'],
            ),

            Expanded(
                // flex: 1,
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 扫一扫
                  // scanCode(),

                  /// 关于我们
                  // aboutUs(),

                  /// 联系客服
                  // contactCustomer(),

                  /// 图表统计
                  // chartCal(),

                  /// 文件上传与下载
                  // fileUplodAndDownload(),
                  // const Divider(),
                  //解绑
                  unbindingDevice(),

                  /// Wi-Fi设置
                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 20.w, bottom: 10.w),
                    child: const TitleWidger(title: 'Wi-Fl设置'),
                  ),

                  /// WLAN设置
                  wlanSet(),

                  /// 访客网络
                  visitorNet(),

                  /// 专业设置
                  majorSet(),

                  /// WPS设置
                  wpsSet(),
                  // const Divider(),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 20.w, bottom: 10.w),
                    child: const TitleWidger(title: '设备信息'),
                  ),

                  /// 设备信息
                  commonProblem(),

                  // const Divider(),

                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 20.w, bottom: 10.w),
                    child: const TitleWidger(title: '系统设置'),
                  ),

                  /// 维护设置
                  maintainSettings(),

                  /// 登录管理
                  accountSecurity(),
                  // const Divider(),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 20.w, bottom: 10.w),
                    child: const TitleWidger(title: '以太网'),
                  ),

                  /// 以太网状态
                  feedback(),

                  ///以太网设置
                  netSet(),
                  // const Divider(),

                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.w, top: 20.w, bottom: 10.w),
                    child: const TitleWidger(title: '网络设置'),
                  ),

                  /// WAN设置
                  wanSettings(),

                  /// DNS设置
                  dnsSettings(),

                  /// Radio设置
                  radioSettings(),

                  /// LAN设置
                  lanSettings(),
                  // const Divider(),

                  /// 系统设置
                  systemSettings(),

                  /// 清除缓存
                  clearCache(),
                  // const Divider(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  //解绑
  _openAvatarBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 260.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w))),
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.w),
                              topRight: Radius.circular(30.w))),
                      height: 80.w,
                      alignment: Alignment.center,
                      child: const Text(
                        "提示",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  CommonWidget.dividerWidget(),
                  InkWell(
                    child: Container(
                      height: 60.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "确定解除对当前设备 ${loginController.equipment['systemVersionSn']} 的绑定?",
                        style:
                            TextStyle(color: Colors.black45, fontSize: 22.sp),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.w)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: 0.5.sw - 30.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          // height: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            "取消",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          height: 60.w,
                          width: 0.5.sw - 30.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          // height: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            "确认",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
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
                  style: TextStyle(color: Colors.white, fontSize: 30.w),
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
                                TextStyle(color: Colors.white, fontSize: 35.w),
                            children: [
                              TextSpan(
                                text: ' 元',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.w),
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
        icon: const Image(image: AssetImage('assets/images/equ_info.png')),
        callBack: () {
          Get.toNamed("/common_problem");
        });
  }

  /// 设备信息
  Widget unbindingDevice() {
    return CommonWidget.simpleWidgetWithMine(
        title: '解绑设备',
        icon: const Image(
          image: AssetImage('assets/images/line.png'),
          width: 28,
          height: 28,
        ),
        callBack: () {
          _openAvatarBottomSheet();
        });
  }

  /// 以太网状态
  Widget feedback() {
    return CommonWidget.simpleWidgetWithMine(
        title: '以太网状态',
        icon: const Image(image: AssetImage('assets/images/net_type.png')),
        callBack: () {
          Get.toNamed("/feed_back");
        });
  }

  /// 维护设置
  Widget maintainSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: '维护设置',
        icon: const Image(image: AssetImage('assets/images/maintain_set.png')),
        callBack: () {
          Get.toNamed("/maintain_settings");
        });
  }

  /// 登录管理
  Widget accountSecurity() {
    return CommonWidget.simpleWidgetWithMine(
        title: '登录管理',
        icon: const Image(image: AssetImage('assets/images/login_admin.png')),
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
        icon: const Image(image: AssetImage('assets/images/clear_cache.png')),
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
          icon: const Image(image: AssetImage('assets/images/sys_set.png')),
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

  /// WAN设置
  Widget wanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WAN设置',
        icon: const Image(image: AssetImage('assets/images/wan.png')),
        callBack: () {
          Get.toNamed("/wan_settings");
        });
  }

  /// DNS设置
  Widget dnsSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'DNS设置',
        icon: const Image(image: AssetImage('assets/images/DNS.png')),
        callBack: () {
          Get.toNamed("/dns_settings");
        });
  }

  /// Radio设置
  Widget radioSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'Radio设置',
        icon: const Image(image: AssetImage('assets/images/radio.png')),
        callBack: () {
          Get.toNamed("/radio_settings");
        });
  }

  /// LAN设置
  Widget lanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'LAN设置',
        icon: const Image(image: AssetImage('assets/images/lan.png')),
        callBack: () {
          Get.toNamed("/lan_settings");
        });
  }

  /// 以太网设置
  Widget netSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '以太网设置',
        icon: const Image(image: AssetImage('assets/images/net_set.png')),
        callBack: () {
          Get.toNamed("/net_set");
        });
  }

  /// WLAN设置
  Widget wlanSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WLAN设置',
        icon: const Image(image: AssetImage('assets/images/wlan.png')),
        callBack: () {
          Get.toNamed("/wlan_set");
        });
  }

  /// 访客网络
  Widget visitorNet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '访客网络',
        icon: const Image(image: AssetImage('assets/images/visitor_net.png')),
        callBack: () {
          Get.toNamed("/visitor_net");
        });
  }

  /// 专业设置
  Widget majorSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: '专业设置',
        icon: const Image(image: AssetImage('assets/images/major_set.png')),
        callBack: () {
          Get.toNamed("/major_set");
        });
  }

  /// WPS设置
  Widget wpsSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'WPS设置',
        icon: const Image(image: AssetImage('assets/images/WPS.png')),
        callBack: () {
          Get.toNamed("/wps_set");
        });
  }
}
