import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/l10n.dart';

class UserPersonalInformation extends StatefulWidget {
  final name;
  const UserPersonalInformation({super.key, this.name});

  @override
  State<UserPersonalInformation> createState() =>
      _UserPersonalInformationState();
}

class _UserPersonalInformationState extends State<UserPersonalInformation> {
  final LoginController loginController = Get.put(LoginController());
  //nickname
  final TextEditingController nicknameController = TextEditingController();
  String nicknameText = "";
  //phone
  final TextEditingController phoneController = TextEditingController();
  String phoneText = "";
  //email
  final TextEditingController emailController = TextEditingController();
  String emailText = "";
  //address
  final TextEditingController addressController = TextEditingController();
  String addressText = "";

  //手机号
  String _userPhone = 'null';
  String sn = 'null';
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  bool loading = false;

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool _isLoading = false;
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      // await setTRDnsData();
    }
    setState(() {
      _isLoading = false;
    });
  }

  File? _imageFile;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    Navigator.pop(context);
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("拍照"),
                onTap: () {
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("相册"),
                onTap: () {
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedGetData('user_phone', String).then(((res) {
      printInfo(info: '用户手机号：$res');
      setState(() {
        _userPhone = res.toString();
      });
    }));
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: customAppbar(context: context, title: ''),
        body: loading
            ? const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: WaterLoading(
                    color: Color.fromARGB(255, 65, 167, 251),
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                child: SingleChildScrollView(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => closeKeyboard(context),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.w, right: 10.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 顶部文本
                          Padding(
                            padding: EdgeInsets.only(top: 16.w, left: 40.w),
                            child: Text(
                              S.of(context).profile,
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 60.w),
                          // 图片上传按钮
                          GestureDetector(
                            onTap: () {
                              _showImagePicker(context);
                            },
                            child: Container(
                              width: 300.w,
                              height: 300.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 74, 195, 189),
                                    width: 5.w),
                                image: _imageFile != null
                                    ? DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: _imageFile == null
                                  ? Icon(Icons.camera_alt, size: 50.w)
                                  : null,
                            ),
                          ),
                          SizedBox(height: 20.w),
                          // 输入框
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            S.of(context).userName,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 74, 195, 189),
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            textAlign: TextAlign.start,
                                            controller: nicknameController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: S.of(context).userName,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 243, 240, 240),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            S.of(context).phone,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 74, 195, 189),
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            textAlign: TextAlign.start,
                                            controller: phoneController,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              hintText: S.of(context).phone,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 243, 240, 240),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: Text(
                                        S.of(context).email,
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 74, 195, 189),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    TextFormField(
                                      textAlign: TextAlign.start,
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: S.of(context).email,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 243, 240, 240),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).homeAddress,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 74, 195, 189),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    TextFormField(
                                      textAlign: TextAlign.start,
                                      controller: addressController,
                                      keyboardType: TextInputType.text,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: S.of(context).homeAddress,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 243, 240, 240),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                GestureDetector(
                                  onTap: () {
                                    // 点击按钮1时执行的代码
                                    printInfo(info: '111');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 243, 240, 240),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lock,
                                            color: Color.fromARGB(
                                                255, 74, 195, 189)),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                        ),
                                        Text(S.of(context).changePassword),
                                        const Spacer(),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 74, 195, 189),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(S.of(context).update),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
