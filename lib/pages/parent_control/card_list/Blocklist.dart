import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

class Blocklist extends StatefulWidget {
  const Blocklist({super.key});

  @override
  _BlocklistState createState() => _BlocklistState();
}

class _BlocklistState extends State<Blocklist> {
  bool? isAllSelected = false;
  final List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Google.jpg',
      'text': 'Google',
      'code': '8001',
    },
    {
      'img': 'assets/images/TikTok.jpg',
      'text': 'Wiki',
      'code': '8002',
    },
    {
      'img': 'assets/images/Yahoo.jpg',
      'text': 'Yahoo',
      'code': '8003',
    },
    {
      'img': 'assets/images/Apple.jpg',
      'text': 'Apple',
      'code': '8004',
    },
    {
      'img': 'assets/images/Reddit.jpg',
      'text': 'Reddit',
      'code': '8010',
    },
    {
      'img': 'assets/images/Outlook.jpg',
      'text': 'Outlook',
      'code': '8011',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Naver',
      'code': '8012',
    },
    {
      'img': 'assets/images/Fandom.jpg',
      'text': 'Fandom',
      'code': '8013',
    },
    {
      'img': 'assets/images/Globo.jpg',
      'text': 'Globo',
      'code': '8015',
    },
    {
      'img': 'assets/images/Yelp.jpg',
      'text': 'Yelp',
      'code': '8016',
    },
    {
      'img': 'assets/images/Pinterest.jpg',
      'text': 'Pinterest',
      'code': '8017',
    },
    {
      'img': 'assets/images/BBC.jpg',
      'text': 'BBC',
      'code': '8018',
    },
    {
      'img': 'assets/images/Linkedin.jpg',
      'text': 'Linkedin',
      'code': '8020',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Merriam-webster',
      'code': '8022',
    },
    {
      'img': 'assets/images/Dictionary.jpg',
      'text': 'Dictionary',
      'code': '8027',
    },
    {
      'img': 'assets/images/Tripadvisor.jpg',
      'text': 'Tripadvisor',
      'code': '8028',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Britannica',
      'code': '8029',
    },
    {
      'img': 'assets/images/Cambridge.jpg',
      'text': 'Cambridge',
      'code': '8030',
    },
    {
      'img': 'assets/images/Weather.jpg',
      'text': 'Weather',
      'code': '8032',
    },
    {
      'img': 'assets/images/Wiktionary.jpg',
      'text': 'Wiktionary',
      'code': '8033',
    },
    {
      'img': 'assets/images/Espn.jpg',
      'text': 'Espn',
      'code': '8034',
    },
    {
      'img': 'assets/images/Microsoft.jpg',
      'text': 'Microsoft',
      'code': '8035',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Gsmarena',
      'code': '8038',
    },
    {
      'img': 'assets/images/Webmd.jpg',
      'text': 'Webmd',
      'code': '8039',
    },
    {
      'img': 'assets/images/Craigslist.jpg',
      'text': 'Craigslist',
      'code': '8040',
    },
    {
      'img': 'assets/images/Cricbuzz.jpg',
      'text': 'Cricbuzz',
      'code': '8041',
    },
    {
      'img': 'assets/images/Mayoclinic.jpg',
      'text': 'Mayoclinic',
      'code': '8042',
    },
    {
      'img': 'assets/images/Timeanddate.jpg',
      'text': 'Timeanddate',
      'code': '8043',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Espncricinfo',
      'code': '8044',
    },
    {
      'img': 'assets/images/Healthline.jpg',
      'text': 'Healthline',
      'code': '8045',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Rottentomatoes',
      'code': '8047',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Thefreedictionary',
      'code': '8049',
    },
    {
      'img': 'assets/images/Bestbuy.jpg',
      'text': 'Bestbuy',
      'code': '8052',
    },
    {
      'img': 'assets/images/Indeed.jpg',
      'text': 'Indeed',
      'code': '8053',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Samsung',
      'code': '8058',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Investopedia',
      'code': '8059',
    },
    {
      'img': 'assets/images/Flashscore.jpg',
      'text': 'Flashscore',
      'code': '8060',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Steampowered',
      'code': '8061',
    },
    {
      'img': 'assets/images/Roblox.jpg',
      'text': 'Roblox',
      'code': '8064',
    },
    {
      'img': 'assets/images/Nordstrom.jpg',
      'text': 'Nordstrom',
      'code': '8065',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Thepiratebay',
      'code': '8066',
    },
    {
      'img': 'assets/images/Indiatimes.jpg',
      'text': 'Indiatimes',
      'code': '8067',
    },
    {
      'img': 'assets/images/Cnbc.jpg',
      'text': 'Cnbc',
      'code': '8068',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Ssyoutube',
      'code': '8069',
    },
    {
      'img': 'assets/images/Adobe.jpg',
      'text': 'Adobe',
      'code': '8070',
    },
    {
      'img': 'assets/images/Speedtest.jpg',
      'text': 'Speedtest',
      'code': '8071',
    },
    {
      'img': 'assets/images/Lowes.jpg',
      'text': 'Lowes',
      'code': '8072',
    },
  ];

  late List<bool?> itemSelections;
  List<String> selectedWebsites = [];
  // Enable
  bool isEnable = false;
  // 搜索框
  final TextEditingController _textEditingController = TextEditingController();
  // url
  String url = '';
  dynamic mac = Get.arguments['mac'];
  dynamic sn = Get.arguments['sn'];
  dynamic formParam = ''; //传输给后台的param
  List<String> allCodes = [];
  @override
  void initState() {
    super.initState();
    itemSelections = List.generate(topData.length, (index) => false);
    getParentControlConfigFn();
  }

  /// 点击空白  关闭输入键盘
  FocusNode blankNode = FocusNode();
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  // url 校验方法
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

  // _isLoading
  bool _isLoading = false;
  // void warningReboot(Function save) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Warning'),
  //         content: const Text(
  //             'It is a warning action, because device will reboot. Confirm to save it?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Save'),
  //             onPressed: () {
  //               save();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    printInfo(info: '111111');

    setParentControlConfigFn();

    setState(() {
      _isLoading = false;
      Navigator.pop(context);
    });
    return;
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
        // 遍历白名单列表
        if (formParam['rules']['websiteapps'] != null) {
          List<String> websiteapps =
              formParam['rules']['websiteapps'].split(' ');
          for (int i = 0; i < topData.length; i++) {
            for (int i = 0; i < topData.length; i++) {
              if (websiteapps.contains(topData[i]['code'])) {
                itemSelections[i] = true;
              } else {
                itemSelections[i] = false;
              }
            }
          }
        }
        // 更改enable状态
        isEnable = formParam['enable'] == '1' ? true : false;
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
      printInfo(info: 'form$form');

      var res = await App.post(
          '${BaseConfig.cloudBaseUrl}/parentControl/setParentControlConfig',
          data: {'s': json.encode(form)},
          header: {'Content-Type': 'application/x-www-form-urlencoded'});
      printInfo(info: 'res$res');
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
      } else {
        ToastUtils.error('Task Failed');
      }

      ToastUtils.toast(S.current.success);
    } catch (e) {
      debugPrint('失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          // IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.black87,
          //   ),
          //   onPressed: () {
          //     // 自定义返回按钮的回调
          //     Navigator.pop(context);
          //   },
          // ),
          title: 'Website Blocklist',
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.w),
              child: OutlinedButton(
                onPressed: () => _saveData(),
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

      //  AppBar(
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.black87,
      //     ),
      //     onPressed: () {
      //       // 自定义返回按钮的回调
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: const Text('Website Blocklist',
      //       style: TextStyle(
      //         color: Colors.black87,
      //       )),
      // ),
      body: GestureDetector(
        onTap: () => closeKeyboard(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enable
            InfoBox(
              boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleWidger(title: 'Enable'),
                    Switch(
                      value: isEnable,
                      onChanged: (newVal) {
                        setState(() {
                          isEnable = newVal;
                          formParam['enable'] = isEnable == true ? '1' : '2';
                        });
                      },
                    ),
                  ]),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 248, 248, 248),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        // style: const TextStyle(
                        //   color: Colors.black87, // 将文本颜色加深
                        // ),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 说明
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Select which apps can access the Internet.',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(136, 135, 135, 1)),
              ),
            ),
            // 总控制
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: CheckboxListTile(
                title: const Text('Select all'),
                value: isAllSelected ?? false,
                onChanged: (value) {
                  setState(() {
                    isAllSelected = value!;
                    itemSelections =
                        List.generate(topData.length, (index) => value);
                    if (isAllSelected != null && isAllSelected!) {
                      allCodes = topData
                          .map((item) => item['code'].toString())
                          .toList();
                      // 在这里使用 allCodes 变量
                      print(allCodes);
                    }
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular apps',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            // 列表
            Expanded(
              child: ListView.builder(
                itemCount: topData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CheckboxListTile(
                      value: itemSelections[index] ?? false,
                      onChanged: (value) {
                        setState(() {
                          itemSelections[index] = value;
                          isAllSelected =
                              itemSelections.every((item) => item ?? false);
                          if (value == true) {
                            selectedWebsites.add(topData[index]['code']);
                            // 判断 websiteapps 是否包含值
                            if (formParam['rules']['websiteapps'] != null &&
                                formParam['rules']['websiteapps'].isNotEmpty) {
                              // 将 websiteapps 中已有的值添加到 selectedWebsites 中
                              List<String> websiteapps =
                                  formParam['rules']['websiteapps'].split(' ');
                              for (String websiteapp in websiteapps) {
                                if (!selectedWebsites.contains(websiteapp)) {
                                  selectedWebsites.add(websiteapp);
                                }
                              }
                            }
                            // 将 selectedWebsites 中的值连接成字符串，并赋值给 websiteapps
                            formParam['rules']['websiteapps'] =
                                selectedWebsites.join(' ');
                          } else {
                            // formParam['rules']['websiteapps']
                            //     .remove(topData[index]['code']);
                            if (formParam['rules']['websiteapps'] != null &&
                                formParam['rules']['websiteapps'].isNotEmpty) {
                              List<String> websiteapps =
                                  formParam['rules']['websiteapps'].split(' ');
                              printInfo(info: 'websiteapps$websiteapps');
                              // printInfo(info: 'websiteapp$websiteapp');

                              websiteapps.remove(topData[index]['code']);
                              printInfo(info: 'websiteapps22222$websiteapps');

                              // formParam['rules']['websiteapps'] =
                              //     websiteapps.join(' ');
                            }
                            // printInfo(info: 'formParam$formParam');
                          }
                        });
                      },
                      title: Text(topData[index]['text']),
                      secondary: Image.asset(topData[index]['img']),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            // Feedback
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't see what you're looking for?",
                    style: TextStyle(color: Color.fromRGBO(136, 135, 135, 1)),
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
                          fontSize: 16, color: Color.fromRGBO(95, 130, 226, 1)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // + 按钮
            SizedBox(
              width: 1.sw,
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 35)),
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
                                if (checkURL(url)) {
                                  // getURLAdd();
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
                  child: Text("Add",
                      style: TextStyle(fontSize: 30.sp, color: Colors.blue)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
