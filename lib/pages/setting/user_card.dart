import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/toast.dart';

class UserCard extends StatefulWidget {
  final String name;
  const UserCard({super.key, required this.name});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final LoginController loginController = Get.put(LoginController());

  //手机号
  String _userPhone = 'null';
  String sn = 'null';
  int userId = 0;
  String downloadImageUrl = "";
  String fileImage = "";

  late XFile _image;
  @override
  void initState() {
    sharedGetData('imageUrl', String).then(((image) {
      if (image != null) {
        setState(() {
          fileImage = image.toString();
        });
      }
    }));
    super.initState();
    sharedGetData('user_phone', String).then(((res) {
      printInfo(info: '用户手机号：$res');
      setState(() {
        _userPhone = res.toString();
      });
    }));
    sharedGetData('deviceSn', String).then(((res) {
      // printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
      });
    }));

    sharedGetData('userAvatar', String).then(((image) {
      debugPrint("获取的头像URL:$image");
      if (image != null) {
        setState(() {
          downloadImageUrl = image as String;
        });
      }
    }));

    sharedGetData('userId', int).then(((id) {
      if (id != null) {
        setState(() {
          userId = int.parse(id.toString());
        });
      }
    }));
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final status = await Permission.photos.request();
    if (status != PermissionStatus.granted) {
      //无相机权限，请前往设置打开
      openAppSettings();
      return;
    }
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    // _upLoadImage(pickedImage!);
    App.uploadImg(pickedImage!).then((response) {
      var dic = jsonDecode(jsonEncode(response));
      if (dic["code"] == 200) {
        ToastUtils.toast("Upload successful");
        Navigator.pop(context);
        setState(() {
          downloadImageUrl = dic["data"];
          _image = pickedImage;
          fileImage = pickedImage.path;
          sharedAddAndUpdate("imageUrl", String, fileImage);
          debugPrint("图片的路径是:${pickedImage.path}");
        });
        updateUserInfo(dic["data"]);
      }
    });
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      openAppSettings();
      return;
    }
    final XFile? captureImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (captureImage != null) {
      // _upLoadImage(captureImage);
      App.uploadImg(captureImage).then((response) {
        var dic = jsonDecode(jsonEncode(response));
        if (dic["code"] == 200) {
          ToastUtils.toast("Upload successful");
          Navigator.pop(context);
          setState(() {
            downloadImageUrl = dic["data"];
            _image = captureImage;
            fileImage = captureImage.path;
            sharedAddAndUpdate("imageUrl", String, fileImage);
            debugPrint("图片的路径是:${captureImage.path}");
          });
          updateUserInfo(dic["data"]);
        }
      });
    }
  }

  updateUserInfo(String image) {
    var parma = {"id": userId, "account": _userPhone, "avatar": image};
    App.put("/platform/appCustomer/update", data: parma).then((value) {
      var dic = jsonDecode(jsonEncode(value));
      debugPrint(dic);
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void showMediaDialogView() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pickImageFromGallery();
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
                  pickImageFromCamera();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => const UserPersonalInformation()),
        // );
        debugPrint("----- name is : ${widget.name}}");
        Get.toNamed("/Personal_Center", arguments: {"name": widget.name})
            ?.then((value) {
          if ((value as String).isNotEmpty) {
            setState(() {
              fileImage = value.toString();
            });
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width - 20,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Color(0xffe5e5e5),
                  offset: Offset(-6.0, 6.0), //阴影x轴偏移量
                  blurRadius: 10, //阴影模糊程度
                  spreadRadius: 0 //阴影扩散程度
                  )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(width: 1, color: const Color(0xffe5e5e5))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showMediaDialogView();
              },
              child: downloadImageUrl.isEmpty
                  ? Image.asset('assets/images/user_info_icon.png',
                          fit: BoxFit.cover, height: 50, width: 50)
                  : (fileImage.isNotEmpty
                      ? ClipOval(
                          child: Image.file(File(fileImage),
                              fit: BoxFit.cover, height: 50, width: 50,errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/user_info_icon.png',
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50);
                              },))
                      : ClipOval(
                          child: Image.network(
                            downloadImageUrl,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/user_info_icon.png',
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50);
                            },
                          ),
                        )),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        _userPhone != 'null'
                            ? _userPhone
                            : S.of(context).noLogin,
                        style: _userPhone != 'null'
                            ? const TextStyle(
                                color: Color.fromARGB(255, 54, 152, 244),
                                fontSize: 16)
                            : TextStyle(
                                fontSize: 40.sp, color: Colors.black38)),
                    Text(
                        _userPhone != 'null'
                            ? '${S.of(context).currentDeive} $sn'
                            : S.of(context).Remote,
                        style:
                            TextStyle(fontSize: 27.sp, color: Colors.black38))
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_userPhone != 'null') {
                            loginController.setState('cloud');
                            printInfo(
                                info: 'state--${loginController.login.state}');
                          }
                          loginOut();
                          debugPrint('清除用户信息');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              _userPhone != 'null'
                                  ? const Color.fromARGB(255, 255, 0, 0)
                                  : const Color.fromRGBO(41, 121, 255, 1)),
                        ),
                        child: Text(
                          _userPhone != 'null'
                              ? S.of(context).logOut
                              : S.of(context).login,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        loginOut();
                      },
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void loginOut() {
    Get.offNamed("/user_login");
    sharedDeleteData('user_phone');
    sharedDeleteData('user_token');
    sharedDeleteData('deviceSn');
  }
}
