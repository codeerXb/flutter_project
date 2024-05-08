import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/parent_control/index.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';

class UserPersonalInformation extends StatefulWidget {
  final String? name;
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
  String _imageFileAvatar = '';
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  bool loading = false;
  // 当前登录账户的信息
  Map<String, dynamic> loginUserInfo = {};

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  void initState() {
    sharedGetData('imageUrl', String).then(((image) {
      if (image != null) {
        setState(() {
          _imageFile = File(image.toString());
        });
      }
    }));
    super.initState();
    name = Get.arguments["name"];
    debugPrint("用户名是:$name");
    sharedGetData('loginUserInfo', String).then(((res) {
      if (res != null) {
        setState(() {
          loginUserInfo = jsonDecode(res.toString());
          // 页面初始更新数据
          nicknameController.text = loginUserInfo['nickname'] ?? '';
          phoneController.text = loginUserInfo['phone'] ?? '';
          emailController.text = loginUserInfo['email'] ?? '';
          addressController.text = loginUserInfo['address'] ?? '';
          _imageFileAvatar = loginUserInfo['avatar'] ?? '';
          printInfo(info: '_imageFileAvatar$_imageFileAvatar');
        });
      }
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

  Future<void> _getImage(ImageSource source) async {
    // 先判断是否授权相机和相册权限
    if (source == ImageSource.camera) {
      checkCameraPermissions();
    } else if (source == ImageSource.gallery) {
      checkGalleryPermissions();
    }
    // 获取照片
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      App.uploadImg(pickedFile).then((response) {
        var dic = jsonDecode(jsonEncode(response));
        if (dic["code"] == 200) {
          ToastUtils.toast("Upload successful");
          Navigator.pop(context);
          setState(() {
            _imageFileAvatar = dic["data"];
            _imageFile = File(pickedFile.path);
            sharedAddAndUpdate("imageUrl", String, pickedFile.path);
          });
        }
      });
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _getImage(ImageSource.gallery);
                },
                child: const SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.photo),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Photo')
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1.0,
                indent: 0,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  _getImage(ImageSource.camera);
                },
                child: const SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Camera')
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1.0,
                indent: 0,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  height: 60,
                  child: Center(
                    child: Text('Cancel'),
                  ),
                ),
              ),
            ],
          );
        });
  }

  // 修改信息 云端
  setData() async {
    var objectName = {
      "id": loginUserInfo['id'],
      "nickname": nicknameController.text,
      "avatar": _imageFileAvatar,
      "phone": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
    };
    var res = await Request().putObject(objectName);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        sharedAddAndUpdate(
            "loginUserInfo", String, jsonEncode(objectName)); //把更新后的信息保存到本地
      } else {
        ToastUtils.error('Task Failed');
      }
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('修改信息失败：${e.toString()}');
    }
  }

  /// 检查是否授权
  checkGalleryPermissions() async {
    PermissionStatus status = await Permission.photos.request();
    if (status != PermissionStatus.granted) {
      openAppSettings();
      return;
    }
  }

  checkCameraPermissions() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      openAppSettings();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(// customAppbar(context: context, title: 'ACCOUNT')
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Get.back(result: _imageFile?.path);
          }, 
          icon: const Icon(Icons.arrow_back_ios)
          ),
          title: const Text("ACCOUNT",style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 20),),
          centerTitle: true,
        ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 顶部文本
                          Padding(
                            padding: EdgeInsets.only(top: 16.w, left: 40.w),
                            child: Text(
                              S.of(context).profile,
                              style: TextStyle(
                                fontSize: 40.sp,
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
                                image: _imageFile != null
                                    ? DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover,onError: (exception, stackTrace) {
                                          
                                        },)
                                    : _imageFileAvatar.isNotEmpty ? DecorationImage(
                                        image: NetworkImage(_imageFileAvatar),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          
                                        },
                                      ) : const DecorationImage(
                                        image: AssetImage("assets/images/user_info_icon.png"),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: Icon(
                                      Icons.camera_alt,
                                      size: 50.w,
                                      color: Colors.lightBlue,
                                    ),
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
                                      maxLines: 2,
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
                                      maxLines: 2,
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
                                        (value) => {debugPrint("新密码：$value")});
                                  },
                                  child: Container(
                                    height: 60,
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
                                          Text(S.of(context).update,
                                              style: const TextStyle(
                                                  color: Colors.white)),
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    
  }
}
