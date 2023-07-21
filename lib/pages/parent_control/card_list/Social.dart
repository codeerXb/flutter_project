import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../config/base_config.dart';
import '../../../core/http/http_app.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

class Social extends StatefulWidget {
  const Social({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool? allChecked = false; // 用于表示Checkbox的选中状态
  bool _isLoading = false;
  dynamic mac = Get.arguments['mac'];
  dynamic sn = Get.arguments['sn'];
  dynamic formParam = ''; //传输给后台的param

  final TextEditingController _textEditingController = TextEditingController();

  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Face book.jpg',
      'text': 'Face book',
      'code': '1001',
      'select': false,
    },
    {
      'img': 'assets/images/Face book.jpg',
      'text': 'Whatsapp',
      'code': '1002',
      'select': false,
    },
    {
      'img': 'assets/images/Twitter.jpg',
      'text': 'Twitter',
      'code': '1003',
      'select': false,
    },
    {
      'img': 'assets/images/Instagram.jpg',
      'text': 'Instagram',
      'code': '1004',
      'select': false,
    },
    {
      'img': 'assets/images/Instagram.jpg',
      'text': 'VK',
      'code': '1005',
      'select': false,
    },
    {
      'img': 'assets/images/Instagram.jpg',
      'text': 'Line',
      'code': '1006',
      'select': false,
    },
    {
      'img': 'assets/images/Instagram.jpg',
      'text': 'Snapchat',
      'code': '1007',
      'select': false,
    },
    {
      'img': 'assets/images/Instagram.jpg',
      'text': 'Tinder',
      'code': '1008',
      'select': false,
    },
  ];
  void setAllCheckBoxes(bool value) {
    for (var item in topData) {
      item['select'] = value;
    }
  }

  void deselectAll() {
    bool allSelected = true;

    for (int i = 0; i < topData.length; i++) {
      if (!topData[i]['select']) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      allChecked = allSelected;
    });
  }

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });

    formParam['rules']['chatapps'] = '';
    for (var element in topData) {
      if (element['select'] == true) {
        formParam['rules']['chatapps'] += element['code'] + ' ';
      }
    }

    setParentControlConfigFn();
  }

  //获取配置
  void getParentControlConfigFn() async {
    try {
      var response = await App.post(
          '${BaseConfig.cloudBaseUrl}/parentControl/getParentControlConfig',
          data: {'sn': sn, "mac": mac});
      var d = json.decode(response.toString());
      setState(() {
        formParam = d['data'];
        print('object$formParam');
        //遍历白名单列表
        d['data']['rules']['chatapps'].split(' ').forEach((item) {
          //遍历数据如果包含
          for (var element in topData) {
            if (element['code'] == item) {
              element['select'] = true;
            }
          }
        });
      });
    } catch (e) {
      debugPrint('失败：$e.toString()');
    }
  }

  //下发配置
  void setParentControlConfigFn() async {
    try {
      var form = {
        'event': 'setParentControlConfig',
        'sn': sn,
        "param": formParam
      };
      await App.post(
          '${BaseConfig.cloudBaseUrl}/parentControl/setParentControlConfig',
          data: {'s': json.encode(form)},
          header: {'Content-Type': 'application/x-www-form-urlencoded'});
      // print('response$response');

      ToastUtils.toast(S.current.success);
    } catch (e) {
      debugPrint('失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: customAppbar(
            context: context,
            title: 'Social media',
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
        body: SingleChildScrollView(
          child: GestureDetector(
            // onTap: () => closeKeyboard(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  // child: Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: const Color.fromARGB(255, 248, 248, 248),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       const Padding(
                  //         padding: EdgeInsets.only(left: 16, right: 8),
                  //         child: Icon(Icons.search),
                  //       ),
                  //       Expanded(
                  //         child: TextField(
                  //           controller: _textEditingController,
                  //           // style: const TextStyle(
                  //           //   color: Colors.black87, // 将文本颜色加深
                  //           // ),
                  //           decoration: const InputDecoration(
                  //             hintText: 'Search',
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select which apps can access the Internet.',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(136, 135, 135, 1)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: CheckboxListTile(
                    title: const Text('Select all'),
                    value: allChecked,
                    onChanged: (value) {
                      setState(() {
                        allChecked = value!;
                        // 当Checkbox的选中状态改变时，将ListView中每个CheckboxListTile的选中状态也改变
                        setAllCheckBoxes(value);
                      });
                    },
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                //   child: Text(
                //     'Popular apps',
                //     style:
                //         TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
                  child: Container(
                      height: 107.h * topData.length,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                    child: Column(
                      children: topData.map((data) {
                        final index = topData.indexOf(data);
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    data['img'],
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(data['text']),
                                  const Spacer(),
                                  Checkbox(
                                    value: data['select'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        data['select'] = newValue;
                                        deselectAll(); //取消全选
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (index != topData.length - 1)
                              const Divider(height: 1),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't see what you're looking for?",
                        style:
                            TextStyle(color: Color.fromRGBO(136, 135, 135, 1)),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Feedback'),
                                content: SizedBox(
                                  width: 400.sp,
                                  child: TextFormField(
                                    // controller: lanTimeController,
                                    decoration: const InputDecoration(
                                      labelText: "Feedback...",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Confirm'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showSnackBar(
                                          context, 'Feedback is successful!');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Feedback',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(95, 130, 226, 1)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
