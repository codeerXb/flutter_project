import 'package:flutter/material.dart';
// import 'package:flutter_template/config/base_config.dart';
// import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../config/constant.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 关于我们
class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String appVersion = "";
  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  void _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      appVersion = version;
    });

    debugPrint("版本信息:$appName -- $packageName -- $version -- $buildNumber --");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'About Us'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 公司首页
            CommonWidget.simpleWidgetWithUserDetail("Website", callBack: () {
              Get.toNamed("/commpanyWebsitePage");
              // debugPrint(
              //     "当前访问的URL地址:${BaseConfig.companyWebProtocol}${BaseConfig.companyWebUrl}");
              // launchUrl(
              //   Uri(

              //       host: "https://codiumnetworks.com/"),
              //   mode: LaunchMode.inAppWebView,
              // );
            }),

            /// 技术服务
            CommonWidget.simpleWidgetWithUserDetail("Technical Support",
                value: '', callBack: () {
              // launchUrl(Uri(scheme: 'tel', path: '13563254789'));
            }),

            /// 服务条款
            // CommonWidget.simpleWidgetWithUserDetail("User Agreement",
            //     callBack: () {
            //   ToastUtils.toast("Feature is under development");
            // }),
            aboutUs()

            /// 公众号信息
            // weixin(),
          ],
        ),
      ),
    );
  }

  Widget aboutUs() {
    return Container(
      padding: EdgeInsets.only(top: 30.w,left: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12,width: 1.0))
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Version :",
            style: TextStyle(fontSize: 16, color: Colors.black54,fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10,),
          Text(
            appVersion,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  /// 公众号信息
  Widget weixin() {
    return Container(
      padding: EdgeInsets.only(top: 100.w),
      child: Column(
        children: [
          SizedBox(
            height: 250.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Constant.wxGongZhongHao,
                      width: 200.w,
                      height: 200.w,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Text(
                        "公众号",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Constant.wxGenRen,
                      width: 200.w,
                      height: 200.w,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Text(
                        "扫一扫 加我微信",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.w),
            child: const Text("版权所有"),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.w),
            child: const Text("copyright© 2022 helsmanli.com"),
          )
        ],
      ),
    );
  }
}
