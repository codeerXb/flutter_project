import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/widget/common_box.dart';

class ChangeUserInfoPageView extends StatefulWidget {
  const ChangeUserInfoPageView({super.key});

  @override
  State<ChangeUserInfoPageView> createState() => _ChangeUserInfoPageViewState();
}

class _ChangeUserInfoPageViewState extends State<ChangeUserInfoPageView> {
  final TextEditingController _oldposswardController = TextEditingController();
  final TextEditingController _newposswardController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final _userInfoKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: "Change Password"
      ),
      body: SafeArea(
        child: Column(
          children: [
            const TitleWidger(title: "Old Password"),
            Padding(
              padding: EdgeInsets.only(top: 20.w,left: 20.w,right: 20.w),
              child: Container(
                height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.r)
              ),
              child: TextFormField(
                autofocus: true,
                    controller: _oldposswardController,
                    decoration: const InputDecoration(hintText: "old password"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "The old password cannot be empty";
                    },
              ),
            ),
            ),
            SizedBox(height: 10.h,),
            const TitleWidger(title: "New Password"),
            Padding(
              padding: EdgeInsets.only(top: 20.w,left: 20.w,right: 20.w),
              child: Container(
                height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.r)
              ),
              child: TextFormField(
                autofocus: true,
                    controller: _oldposswardController,
                    decoration: const InputDecoration(hintText: "new password"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "The new password cannot be empty";
                    },
              ),
            ),
            ),
          ],
        )
        ),
    );
  }
}