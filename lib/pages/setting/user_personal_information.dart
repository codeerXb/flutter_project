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
    if (loginController.login.state == 'local') {
      // 本地请求赋值
      // if (dsnMain.text == '' &&
      //     dsnMain1.text == '' &&
      //     dsnMain2.text == '' &&
      //     dsnMain3.text == '' &&
      //     dsnAssist.text == '' &&
      //     dsnAssist1.text == '' &&
      //     dsnAssist2.text == '' &&
      //     dsnAssist3.text == '') {
      //   getRadioData();
      // } else {
      //   getRadioSettingData();
      // }
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
        appBar: customAppbar(
            context: context,
            title: 'Personal Information',
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(20.w),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
                  child: Row(
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      if (!_isLoading)
                        Text(
                          S.current.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _isLoading ? Colors.grey : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]),
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
            : SingleChildScrollView(
                child: InkWell(
                  onTap: () => closeKeyboard(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 顶部文本
                      Padding(
                        padding: EdgeInsets.only(top: 20.w, left: 40.w),
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.w),
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
                                color: Colors.grey[300]!, width: 5.w),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("顶部文字"),
                            const SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {
                                // 处理上传图片的逻辑
                              },
                              child: Container(
                                width: double.infinity,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(Icons.camera_alt, size: 50.0),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          hintText: "输入框1",
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          hintText: "输入框2",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          hintText: "输入框3",
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          hintText: "输入框4",
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          hintText: "输入框5",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
