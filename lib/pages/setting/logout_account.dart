import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

class DelAccountPage extends StatefulWidget {
  const DelAccountPage({super.key});

  @override
  State<DelAccountPage> createState() => _DelAccountPageState();
}

class _DelAccountPageState extends State<DelAccountPage> {

  String userAccount = "";
  @override
  void initState() {
    userAccount = Get.arguments["userAccount"];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Account Deletion',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width,minHeight:10 ,maxHeight: MediaQuery.of(context).size.height),
          child: Container(
          height: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(247, 248, 251, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width - 30,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Account Deletion",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "If you delete account, the device information and personal information bound to the account will be  eliminated. Please operate carefully. Do you want to continue to delete your account?",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(
                                        20.w, 28.w, 20.w, 28.w)),
                                shape: MaterialStateProperty.all(
                                    const StadiumBorder()),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(255, 89, 89, 1)),
                              ),
                              onPressed: () {
                                logOutUserAccount();
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    fontSize: 32.sp, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w),
                                ),
                                shape: MaterialStateProperty.all(
                                    const StadiumBorder()),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(255, 255, 255, 1)),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color:
                                        const Color.fromRGBO(1, 113, 247, 1)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),),
        ));
  }

  logOutUserAccount() {
    
    App.delete('/platform/appCustomer/deleteByAccount?account=$userAccount')
        .then((res) {
      var d = json.decode(res.toString());
      debugPrint('响应------>$d');
      if (d['code'] == 200) {
        ToastUtils.toast(d['message']);
        Get.offAllNamed("/user_login");
        sharedDeleteData('user_phone');
        sharedDeleteData('user_token');
        sharedDeleteData('deviceSn');
        debugPrint('清除用户信息');
      } else {}
    }).catchError((err) {});
  }
}
