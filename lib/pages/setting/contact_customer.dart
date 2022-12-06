import 'package:flutter/material.dart';
import 'package:flutter_template/config/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 联系客服
class ContactCustomer extends StatefulWidget {
  const ContactCustomer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactCustomerState();
}

class _ContactCustomerState extends State<ContactCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '联系客服'),
      body: SingleChildScrollView(
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Container(
              padding: EdgeInsets.only(
                  left: Constant.paddingLeftRight,
                  right: Constant.paddingLeftRight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  topPicture(),
                  contactPhone(),
                  weixin(),
                  qq(),
                ],
              ),
            )),
      ),
    );
  }

  /// 上方图片
  Widget topPicture() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.pink, borderRadius: BorderRadius.circular(20.w)),
      height: 250.w,
      child: Image.network(
        "http://www.itying.com/images/flutter/7.png",
        fit: BoxFit.fill,
      ),
    );
  }

  /// 联系电话
  Widget contactPhone() {
    return CommonWidget.listTileWithMine(
        title: "联系电话",
        desc: "13569874523",
        leadingBackgroundColor: Colors.white,
        leading: const Icon(
          Icons.phone,
          color: Color.fromRGBO(243, 174, 69, 1),
        ),
        callBack: () {
          launchUrl(Uri(scheme: 'tel', path: '13569874523'));
        });
  }

  /// 官方微信
  Widget weixin() {
    return CommonWidget.listTileWithMine(
        title: "官方微信",
        desc: "识别二维码，关注官方微信",
        leadingBackgroundColor: Colors.white,
        leading: const Icon(
          Icons.wechat_outlined,
          color: Color.fromRGBO(54, 201, 86, 1),
        ),
        callBack: () {
          print("添加官方微信");
        });
  }

  /// 官方QQ
  Widget qq() {
    return CommonWidget.listTileWithMine(
        title: "官方QQ",
        desc: "849270773、738664715",
        leadingBackgroundColor: Colors.white,
        leading: const Icon(
          Icons.snapchat_outlined,
          color: Color.fromRGBO(54, 201, 86, 1),
        ),
        callBack: () {
          print("添加官方QQ");
        });
  }
}
