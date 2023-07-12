import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
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
  // avatar
  // late var avatar = '';

  File? _imageFile;

  //手机号
  final String _userPhone = 'null';
  String sn = 'null';
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  bool loading = false;
  // 当前登录账户的信息
  Map<String, dynamic> loginUserInfo = {};

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedGetData('loginUserInfo', String).then(((res) {
      printInfo(info: 'res$res');
      setState(() {
        loginUserInfo = jsonDecode(res.toString());
        // 租约时间
        nicknameController.text = loginUserInfo['nickname'] ?? '';
        phoneController.text = loginUserInfo['phone'] ?? '';
        emailController.text = loginUserInfo['email'] ?? '';
        addressController.text = loginUserInfo['address'] ?? '';
        // _imageFile = loginUserInfo['avatar'];

        // main();
      });
    }));
    nicknameController.addListener(() {
      debugPrint('监听名字：${nicknameController.text}');
    });
    phoneController.addListener(() {
      debugPrint('监听手机号：${phoneController.text}');
    });
    emailController.addListener(() {
      debugPrint('监听Email：${emailController.text}');
    });
    addressController.addListener(() {
      debugPrint('监听地址：${addressController.text}');
    });
  }

  // void main() async {
  //   final url = loginUserInfo['avatar'];
  //   print('11111$url'); // 输出结果为 File:

  //   final response = await http.get(Uri.parse(url));
  //   print('222222$response'); // 输出结果为 File:

  //   final bytes = response.bodyBytes;
  //   print('333333333$bytes'); // 输出结果为 File:
  //   final directory = Directory('assets/new_file');
  //   if (!directory.existsSync()) {
  //     directory.createSync(recursive: true);
  //   }

  //   final file = File('assets/new_file/file.webp');
  //   print('4444444$file'); // 输出结果为 File:

  //   await file.writeAsBytes(bytes);
  //   print(file); // 输出结果为 File: 'path/to/new/file.webp'
  // }

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
                  printInfo(info: '2222${ImageSource.camera}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("相册"),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  printInfo(info: '11111111111${ImageSource.gallery}');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 设置 云端
  setData() async {
    var objectName = {
      "id": loginUserInfo['id'],
      "nickname": nicknameController.text,
      "avatar": loginUserInfo['avatar'],
      "phone": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
    };
    printInfo(info: '111$objectName');
    var res = await Request().putObject(objectName);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        sharedAddAndUpdate("loginUserInfo", String, objectName); //把更新后的信息保存到本地
      } else {
        ToastUtils.error('Task Failed');
      }
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('修改信息失败：${e.toString()}');
    }
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
                                        const Color.fromARGB(255, 85, 137, 233),
                                    width: 5.w),
                                image:
                                    // Image.network(loginUserInfo['avatar']),
                                    _imageFile != null
                                        //     &&
                                        //         Image.network()
                                        // loginUserInfo['avatar'] != ''
                                        ? DecorationImage(
                                            image: FileImage(_imageFile!),
                                            fit: BoxFit.cover)
                                        : null,
                              ),
                              child: _imageFile == null &&
                                      loginUserInfo['avatar'] == ''
                                  ? Icon(Icons.camera_alt, size: 50.w)
                                  : Icon(Icons.camera_alt, size: 50.w),
                              // Image.network(loginUserInfo['avatar']),
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
                                                  255, 85, 137, 233),
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
                                                  255, 85, 137, 233),
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
                                              Color.fromARGB(255, 85, 137, 233),
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
                                            Color.fromARGB(255, 85, 137, 233),
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
                                    Get.toNamed("/account_security")?.then(
                                        (value) => {print("新密码：$value")});
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
                                                255, 85, 137, 233)),
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
                                    onPressed: () {
                                      setData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 85, 137, 233),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(S.of(context).update),
                                        ],
                                      ),
                                    )),
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
