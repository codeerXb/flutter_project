import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widget/common_box.dart';
import '../../generated/l10n.dart';

/// 系统设置
class SystemSettings extends StatefulWidget {
  const SystemSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  int index = 0;
  String showVal = '中文';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //读取语言 选项
    // sharedGetData('langue', String).then(((res) {
    //   print('当前语言----->$res');
    //   if (res != null) {
    //     setState(() {
    //       showVal = res.toString();
    //       index = [
    //         // S.current.FollowerSystem,
    //         '中文',
    //         'Engish',
    //       ].indexOf(showVal);
    //     });
    //   }
    // }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
              // toolbarController.setPageIndex(2);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          S.of(context).SystemSettings,
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //系统设置
              TitleWidger(title: S.current.SystemSettings),

              InfoBox(
                boxCotainer: Column(children: [
                  //版本更新
                  GestureDetector(
                    onTap: () {
                      debugPrint('版本更新');
                    },
                    child: BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.versionUpdating,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: const Color.fromRGBO(144, 147, 153, 1),
                            size: 30.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  //隐私政策
                  GestureDetector(
                    onTap: () {
                      debugPrint('隐私政策');
                    },
                    child: BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.privacyPolicy,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: const Color.fromRGBO(144, 147, 153, 1),
                            size: 30.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //用户协议
                  GestureDetector(
                    onTap: () {
                      debugPrint('用户协议');
                    },
                    child: BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.userAgreement,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: const Color.fromRGBO(144, 147, 153, 1),
                            size: 30.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //选择语言
                  // GestureDetector(
                  //   onTap: () {
                  //     toolbarController.setPageIndex(1);
                  //     print('ress----> ${S.delegate}');
                  //     var result = CommonPicker.showPicker(
                  //       context: context,
                  //       options: [
                  //         // S.current.FollowerSystem,
                  //         '中文',
                  //         'Engish',
                  //       ],
                  //       value: index,
                  //     );
                  //     result?.then((selectedValue) => {
                  //           if (index != selectedValue && selectedValue != null)
                  //             {
                  //               setState(() => {
                  //                     index = selectedValue,
                  //                     showVal = [
                  //                       // S.current.FollowerSystem,
                  //                       '中文',
                  //                       'Engish',
                  //                     ][index],
                  //                     //存储语言
                  //                     sharedAddAndUpdate(
                  //                         'langue', String, showVal),
                  //                     index == 0
                  //                         ? S.load(const Locale("zh", "CN"))
                  //                         : S.load(const Locale("CN", "zh"))
                  //                   })
                  //             }
                  //         });
                  //   },
                  //   child: BottomLine(
                  //     rowtem: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(S.of(context).language,
                  //             style: TextStyle(
                  //                 color: const Color.fromARGB(255, 5, 0, 0),
                  //                 fontSize: 28.sp)),
                  //         Row(
                  //           children: [
                  //             Text(showVal,
                  //                 style: TextStyle(
                  //                     color: const Color.fromARGB(255, 5, 0, 0),
                  //                     fontSize: 28.sp)),
                  //             Icon(
                  //               Icons.arrow_forward_ios_outlined,
                  //               color: const Color.fromRGBO(144, 147, 153, 1),
                  //               size: 30.w,
                  //             )
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ]),
              ),

              //退出登录
              // Padding(
              //     padding: EdgeInsets.only(top: 15.w),
              //     child: Center(
              //         child: SizedBox(
              //       height: 70.sp,
              //       width: 680.sp,
              //       child: ElevatedButton(
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all(
              //                 const Color.fromARGB(255, 48, 118, 250))),
              //         onPressed: loginout,
              //         child: Text(
              //           S.of(context).logOut,
              //           style: TextStyle(fontSize: 36.sp),
              //         ),
              //       ),
              //     )))
            ],
          ),
        ),
      ),
    );
  }

  /// 退出登录
  // void loginout() async {
  //   // 这里还需要调用后台接口的方法
  //   Dio dio = Dio();
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.badCertificateCallback = (cert, host, port) {
  //       return true; // 返回true强制通过
  //     };
  //     return null;
  //   };
  //   try {
  //     await dio.post('${BaseConfig.baseUrl}/action/logout');
  //   } on DioError catch (err) {
  //     if (err.message.toString().contains('302')) {
  //       sharedDeleteData("loginInfo");
  //       sharedDeleteData("session");
  //       sharedDeleteData("token");
  //       sharedDeleteData("sn");
  //       Get.offAllNamed("/get_equipment");
  //     } else {
  //       //退出登录失败，请检查网络！
  //       ToastUtils.error(S.current.checkNet);
  //     }
  //     printError(info: err.toString());
  //   }
  // }
}
