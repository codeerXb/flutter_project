import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/string_util.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/model/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 用户详情
class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  /// 用户信息
  late UserModel userModel;

  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userModel = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '个人信息'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 头像
              avatarWidget(),

              /// 部门名称
              deptNameWidget(),

              /// 手机号
              phoneWidget(),

              /// 邮箱
              emailWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 头像
  Widget avatarWidget() {
    return CommonWidget.simpleWidgetWithUserDetail("头像",
        value: userModel.avatar, isImage: true, callBack: () {
      print("更换头像");
      _openAvatarBottomSheet();
    });
  }

  /// 部门名称
  Widget deptNameWidget() {
    return CommonWidget.simpleWidgetWithUserDetail("部门名称",
        value: userModel.deptName);
  }

  /// 手机号
  Widget phoneWidget() {
    return CommonWidget.simpleWidgetWithUserDetail("手机",
        value: userModel.phone);
  }

  /// 邮箱
  Widget emailWidget() {
    return CommonWidget.simpleWidgetWithUserDetail("邮箱",
        value: userModel.email);
  }

  ///更换头像
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
                      "拍摄",
                    ),
                  ),
                  onTap: () async {
                    XFile? pickedFile =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (StringUtil.isNotEmpty(pickedFile)) {
                      File imageFile = File(pickedFile?.path ?? "");
                      String name = imageFile.path.substring(
                          imageFile.path.lastIndexOf("/") + 1,
                          imageFile.path.length);
                      print("name:$name");
                    }
                  },
                ),
                CommonWidget.dividerWidget(),
                InkWell(
                  child: Container(
                    height: 80.w,
                    alignment: Alignment.center,
                    child: const Text(
                      "从相册中选择",
                    ),
                  ),
                  onTap: () async {
                    XFile? pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (StringUtil.isNotEmpty(pickedFile)) {
                      File imageFile = File(pickedFile?.path ?? "");
                      String name = imageFile.path.substring(
                          imageFile.path.lastIndexOf("/") + 1,
                          imageFile.path.length);
                      print("name:$name");
                    }
                  },
                ),
                Container(
                  height: 16.w,
                  decoration: const BoxDecoration(color: Color(0xffEEEFF2)),
                ),
                InkWell(
                  child: Container(
                    height: 80.w,
                    alignment: Alignment.center,
                    child:  Text(
                     S.current.cancel,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );
        });
  }
}
