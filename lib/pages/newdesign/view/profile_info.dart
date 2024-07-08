import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/utils/color_utils.dart';

class ProfileInfoPageView extends StatefulWidget {
  const ProfileInfoPageView({super.key});

  @override
  State<ProfileInfoPageView> createState() => _ProfileInfoPageViewState();
}

class _ProfileInfoPageViewState extends State<ProfileInfoPageView> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget userHeadImageView() {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(55)),
          child: Image.asset(""),
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: Image.asset(""),
        )
      ],
    );
  }

  Widget profileInfoPanel() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: InfoBox(
            boxCotainer: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Text(
                    "Nick Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _nickNameController,
                    decoration: InputDecoration(hintText: "nickname"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "Nicknames cannot be null";
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "email"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "email cannot be null";
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _phoneController,
                    decoration: InputDecoration(hintText: "phone number"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "phone number cannot be null";
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _addressController,
                    decoration: InputDecoration(hintText: "address"),
                    validator: (v) {
                      return v!.trim().isNotEmpty
                          ? null
                          : "address cannot be null";
                    },
                  )
                ],
              ),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: "Profile",
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 头像
              userHeadImageView(),
              const SizedBox(
                height: 15,
              ),
              profileInfoPanel(),
              Positioned(
                  bottom: 50,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 190).w,
                    height: 48,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: ColorUtils.hexToColor("#2B7AFB"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            //验证通过提交数据
                          }
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        )),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
