import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/left_slide_actions.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

class Blocklist extends StatefulWidget {
  const Blocklist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocklistState();
}

class _BlocklistState extends State<Blocklist> {
  List<String> _itemTextList = [];
  final Map<String, VoidCallback> _mapForHideActions = {};
  bool isCheck = false;
  bool loading = true;
  final LoginController loginController = Get.put(LoginController());
  String sn = '';

  bool checkURL(String value) {
    RegExp regExp = RegExp(
      r"^((http|https|ftp)\://)?([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-\_]+\.)*[a-zA-Z0-9\-\_]+\.[a-zA-Z]{2,4})(\:[0-9]+)?(/[^/][a-zA-Z0-9\.\,\?\'\\/\\\+&%\$\=~_\@\-\s]*)*$",
      multiLine: false,
    );
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) async {
      sn = res.toString();
      if (mounted) {
        setState(() {
          loading = true;
        });
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          // 云端请求赋值
          await getURLFilter();
        }
        setState(() {
          loading = false;
        });
      }
    }));
  }

// 获取
  getURLFilter() async {
    var sn = await sharedGetData('deviceSn', String);
    setState(() {
      loading = true;
      sn = sn.toString();
    });
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Security.URLFilter",
    ];
    var response = await Request().getACSNode(parameterNames, sn);
    try {
      Map<String, dynamic> d = jsonDecode(response);
      setState(() {
        loading = false;
        Map<String, dynamic> urlFilterList = d['data']['InternetGatewayDevice']
            ['WEB_GUI']['Security']['URLFilter']['List'];
        urlFilterList.forEach((key, value) {
          if (value is Map &&
              value['URL'] != null &&
              value['URL']['_value'] is String) {
            _itemTextList
                .add('{"id": "$key", "value": "${value['URL']['_value']}"}');
          }
        });
        printInfo(info: 'urlFilterList$urlFilterList');
        printInfo(info: '_itemTextList$_itemTextList');
      });
    } catch (e) {
      loading = false;
      debugPrint('获取设备信息失败：${e.toString()}');
    }
  }

  // 设置
  setUrlData(id, url) async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.Security.URLFilter.List.$id.URL",
        url,
        'xsd:string'
      ],
    ];
    printInfo(info: 'parameterNames$parameterNames');
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        getURLFilter();
        _itemTextList = [];
      } else {
        ToastUtils.error('Task Failed');
      }
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  void warningReboot(Function save) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'It is a warning action, because device will reboot. Confirm to save it?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                save();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Website Blocklist'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Expanded(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.sp),
                  ),
                  InfoBox(
                    boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitleWidger(title: 'Enable'),
                          Switch(
                            value: isCheck,
                            onChanged: (newVal) {
                              setState(() {
                                isCheck = newVal;

                                // getAccessOpen();
                              });
                            },
                          ),
                        ]),
                  ),
                  // 列表
                  if (_itemTextList.isNotEmpty)
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        // height: 1.sh - 55,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
                          itemCount: _itemTextList.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            if (index < _itemTextList.length) {
                              final String tempStr = _itemTextList[index];
                              return LeftSlideActions(
                                key: Key(tempStr),
                                actionsWidth: 120,
                                actions: [
                                  // 修改
                                  _buildChangeBtn(index),
                                  // 删除
                                  _buildDeleteBtn(index)
                                ],
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                actionsWillShow: () {
                                  // 隐藏其他列表项的行为。
                                  for (int i = 0;
                                      i < _itemTextList.length;
                                      i++) {
                                    if (index == i) {
                                      continue;
                                    }
                                    String tempKey = _itemTextList[i];
                                    VoidCallback? hideActions =
                                        _mapForHideActions[tempKey];
                                    if (hideActions != null) {
                                      hideActions();
                                    }
                                  }
                                },
                                exportHideActions: (hideActions) {
                                  _mapForHideActions[tempStr] = hideActions;
                                },
                                child: _buildListItem(index),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          // 添加下面这句 内容未充满的时候也可以滚动。
                          physics: const AlwaysScrollableScrollPhysics(),
                          // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
                          //shrinkWrap: true,
                        ),
                      ),
                    ),

                  if (!_itemTextList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      // height: 1.sh - 55,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.content_paste,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text('No URLs'),
                          ],
                        ),
                      ),
                    ),

                  // + 按钮
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Positioned(
                      bottom: 100,
                      child: SizedBox(
                        width: 1.sw,
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(150, 35)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffffffff)), //背景颜色
                              foregroundColor: MaterialStateProperty.all(
                                  const Color(0xff5E6573)), //字体颜色
                              overlayColor: MaterialStateProperty.all(
                                  const Color(0xffffffff)), // 高亮色
                              shadowColor: MaterialStateProperty.all(
                                  const Color(0xffffffff)), //阴影颜色
                              elevation: MaterialStateProperty.all(0), //阴影值
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 12)), //字体
                              side: MaterialStateProperty.all(const BorderSide(
                                  width: 1, color: Color(0xffCAD0DB))), //边框
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ), //圆角弧度
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Add'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'URL',
                                            hintText: 'https://example.com',
                                          ),
                                          onChanged: (value) {
                                            url = value;
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(S.current.cancel),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text(S.current.confirm),
                                        onPressed: () {
                                          // 在这里处理确定按钮的逻辑
                                          Navigator.of(context).pop();
                                          Future<void> executeRequests() async {
                                            try {
                                              // final result1 = await makeRequest1();
                                              // final result2 =
                                              //     await makeRequest2(result1);
                                              // final result3 =
                                              //     await makeRequest3(result2);
                                              // final result4 =
                                              //     await makeRequest4(result3);

                                              // 处理请求结果
                                              // handleResults(
                                              //     result1, result2, result3, result4);
                                            } catch (e) {
                                              // 处理错误
                                              // handleError(e);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Add",
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.blue)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: 0,
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 150,
                  //     child: Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: ElevatedButton(
                  //         onPressed: () {},
                  //         child: const Text('按钮'),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ]),
              ),
            ),
    );
  }

  Widget _buildListItem(final int index) {
    return Container(
        height: 130.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // 阴影颜色。
              color: Color(0x66EBEBEB),
              // 阴影xy轴偏移量。
              offset: Offset(0.0, 0.0),
              // 阴影模糊程度。
              blurRadius: 6.0,
              // 阴影扩散程度。
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.sp),
            ),
            Text('URL',
                style: TextStyle(
                    color: const Color.fromARGB(255, 5, 0, 0),
                    fontSize: ScreenUtil().setWidth(30.0))),
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
            ),
            Text(jsonDecode(_itemTextList[index])['value'],
                style: TextStyle(
                    color: const Color.fromRGBO(147, 148, 168, 1),
                    fontSize: ScreenUtil().setWidth(28.0))),
          ],
        ));
  }

  Widget _buildDeleteBtn(final int index) {
    return GestureDetector(
      onTap: () {
        _openAvatarBottomSheet();
        setState(() {
          // del = accessList.fwParentControlTable![index].id!;
        });
      },
      child: Container(
        width: 60,
        color: const Color(0xFFF20101),
        alignment: Alignment.center,
        child: Text(
          S.current.delete,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }

  // 删除
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
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
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
                      child: Text(
                        S.current.hint,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 60.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        S.current.delPro,
                        style:
                            TextStyle(color: Colors.black45, fontSize: 22.sp),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.w)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: 0.5.sw - 30.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            S.current.cancel,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          // getAccessDel();
                        },
                        child: Container(
                          height: 60.w,
                          width: 0.5.sw - 30.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            S.current.confirm,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  String url = '';
  // 修改
  Widget _buildChangeBtn(final int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      hintText: 'https://example.com',
                    ),
                    onChanged: (value) {
                      url = value;
                      printInfo(info: 'url$url');
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.current.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(S.current.confirm),
                  onPressed: () {
                    // 在这里处理确定按钮的逻辑
                    if (checkURL(url)) {
                      var indexVal = jsonDecode(_itemTextList[index])['id'];
                      printInfo(info: 'aa$indexVal');
                      // 设置
                      setUrlData(indexVal, url);
                      //async {
                      //   var parameterNames = [
                      //     [
                      //       "InternetGatewayDevice.WEB_GUI.Security.URLFilter.List.$indexVal",
                      //       url,
                      //       'xsd:string'
                      //     ],
                      //   ];
                      //   printInfo(info: 'parameterNames$parameterNames');
                      // var res =
                      //     await Request().setACSNode(parameterNames, sn);
                      // try {
                      //   var jsonObj = jsonDecode(res);
                      //   if (jsonObj['code'] == 200) {
                      //     ToastUtils.toast('success');
                      //   } else {
                      //     ToastUtils.error('Task Failed');
                      //   }
                      //   printInfo(info: '````$jsonObj');
                      //   setState(() {});
                      // } catch (e) {
                      //   debugPrint('获取信息失败：${e.toString()}');
                      // }
                      // }

                      // URL格式正确
                      Navigator.of(context).pop();
                    } else {
                      // URL格式错误，弹出提示框
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Invalid URL'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 60,
        color: Colors.green,
        alignment: Alignment.center,
        child: Text(
          S.current.modification,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0.w),
        margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.w),
        ),
        child: boxCotainer);
  }
}

// add 弹窗
// class AddUrl extends StatefulWidget {
//   @override
//   AddUrlState createState() => AddUrlState();
// }

// class AddUrlState extends State<AddUrl> {
//   final TextEditingController _urlController = TextEditingController();

//   @override
//   void dispose() {
//     _urlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: const InputDecoration(
//                 labelText: 'URL',
//                 hintText: 'https://example.com',
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(S.current.cancel),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             String url = _urlController.text;
//             // Do something with the URL
//             Navigator.pop(context);
//           },
//           child: Text(S.current.confirm),
//         ),
//       ],
//     );
//   }
// }
