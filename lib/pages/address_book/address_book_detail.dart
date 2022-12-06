import 'package:flutter/material.dart';
import 'package:flutter_template/config/constant.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/model/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/custom_app_bar.dart';

/// 通讯里详情
class AddressBookDetail extends StatefulWidget {
  const AddressBookDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddressBookDetailState();
}

class _AddressBookDetailState extends State<AddressBookDetail> {

  /// 用户信息
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    print("获取到的用户名：${Get.arguments}");
    setState(() {
      userModel = UserModel(userId: '1234566', userName: 'admin', nickName: '管理员', avatar: 'http://www.itying.com/images/flutter/7.png',
      deptId: '11111', deptName: '研发部', phone: '13258965478', email: '852369745@qq.com', employeeNumber: "001");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context:context, title: '详情', borderBottom: false),
      body: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(240, 240, 240, 1)
          ),
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
                        SizedBox(height: 20.w,),
                        /// 公司
                        commonDetailWidget(Icons.home_filled, "公司", userModel.deptName??""),
                        /// 所属部门
                        commonDetailWidget(Icons.lan_outlined, "所属部门", userModel.deptName??""),
                        /// 岗位
                        commonDetailWidget(Icons.person_outline, "岗位", userModel.deptName??""),
                        /// 手机
                        commonDetailWidget(Icons.phone_outlined, "手机", userModel.phone??"", descColor: const Color.fromRGBO(91, 149, 255, 1), callBack: (){
                          if(null != userModel.phone && '' != userModel.phone){
                            launchUrl(Uri(scheme: 'tel', path: userModel.phone));
                          } else {
                            ToastUtils.toast("无号码");
                          }
                        }),
                        /// 邮箱
                        commonDetailWidget(Icons.email_outlined, "邮箱", userModel.email??""),
                      ],
                    ),
                  ))
            ],
          ),
      ),
    );
  }

  /// 头部
  Widget topWidget(){
    return Container(
      height: 150.w,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 头像 + 名字
          Container(
            height: 100.w,
            margin: EdgeInsets.only(top: 20.w),
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: -25.w, right: -25.w, top: 8.w),
              leading: CommonWidget.imageWidget(imageUrl: userModel.avatar, hasDefault: true, circular: 50.w),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userModel.nickName??"", style: TextStyle(color: const Color.fromRGBO(0, 0, 0, 0.7), fontSize: 28.sp),),
                  SizedBox(height: 15.w,),
                  Text("员工编号：${userModel.employeeNumber}", style: TextStyle(color: const Color.fromRGBO(0, 0, 0, 0.5), fontSize: 22.sp),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 公用组件
  Widget commonDetailWidget(IconData icon, String title, String desc, {Function? callBack, Color? descColor = const Color.fromRGBO(0, 0, 0, 0.7)}){
    return Container(
      height: 100.w,
      padding: EdgeInsets.only(left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
      decoration: const BoxDecoration(
          color: Colors.white
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromRGBO(153, 159, 176, 1),size: 40.w,),
          Container(
            width: 200.w,
            margin: EdgeInsets.only(left: 10.w),
            child: Text(title, style: const TextStyle(color: Color.fromRGBO(153, 159, 176, 1)),),
          ),
          callBack != null ? InkWell(
            onTap: () => callBack(),
            child: Text(desc, style: TextStyle(color: descColor),),
          ) : Text(desc, style: TextStyle(color: descColor),),
        ],
      ),
    );
  }

}
