import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

class Blocklist extends StatefulWidget {
  const Blocklist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocklistState();
}

class _BlocklistState extends State<Blocklist> {
  List<String> _itemTextList = [];
  bool isCheck = false;
  bool loading = true;
  final LoginController loginController = Get.put(LoginController());
  String sn = '';
  int id = 0;
  String url = '';
  final TextEditingController editUrlController = TextEditingController();

  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool? _isChecked = true; // 用于表示Checkbox的选中状态

  final TextEditingController _textEditingController = TextEditingController();
  List<bool> selected1 = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Google',
      'code': '8001',
    },
    {
      'img': 'assets/images/TikTok.jpg',
      'text': 'Wiki',
      'code': '8002',
    },
    {
      'img': 'assets/images/Netflix.jpg',
      'text': 'Yahoo',
      'code': '8003',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Apple',
      'code': '8004',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Reddit',
      'code': '8010',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Outlook',
      'code': '8011',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Naver',
      'code': '8012',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Fandom',
      'code': '8013',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Globo',
      'code': '8015',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Yelp',
      'code': '8016',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Pinterest',
      'code': '8017',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'BBC',
      'code': '8018',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Linkedin',
      'code': '8020',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Merriam-webster',
      'code': '8022',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Dictionary',
      'code': '8027',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Tripadvisor',
      'code': '8028',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Britannica',
      'code': '8029',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Cambridge',
      'code': '8030',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Weather',
      'code': '8032',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Wiktionary',
      'code': '8033',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Espn',
      'code': '8034',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Microsoft',
      'code': '8035',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Gsmarena',
      'code': '8038',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Webmd',
      'code': '8039',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Craigslist',
      'code': '8040',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Cricbuzz',
      'code': '8041',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Mayoclinic',
      'code': '8042',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Timeanddate',
      'code': '8043',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Espncricinfo',
      'code': '8044',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
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
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Bestbuy',
      'code': '8052',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
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
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Flashscore',
      'code': '8060',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Steampowered',
      'code': '8061',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Roblox',
      'code': '8064',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Nordstrom',
      'code': '8065',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Thepiratebay',
      'code': '8066',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Indiatimes',
      'code': '8067',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Cnbc',
      'code': '8068',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Ssyoutube',
      'code': '8069',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Adobe',
      'code': '8070',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Speedtest',
      'code': '8071',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Lowes',
      'code': '8072',
    },
  ];

  void setAllCheckBoxes(bool value) {
    for (int i = 0; i < selected1.length; i++) {
      selected1[i] = value;
    }
  }

  void updateAllCheckBoxes() {
    bool allSelected = true;
    for (int i = 0; i < selected1.length; i++) {
      if (!selected1[i]) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      _isChecked = allSelected;
    });
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
    editUrlController.addListener(() {
      debugPrint('6测试${editUrlController.text}');
    });
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
        _itemTextList = [];
        urlFilterList.forEach((key, value) {
          if (value is Map &&
              value['URL'] != null &&
              value['URL']['_value'] is String) {
            _itemTextList
                .add('{"id": "$key", "value": "${value['URL']['_value']}"}');
          }
        });
        isCheck = d['data']['InternetGatewayDevice']['WEB_GUI']['Security']
            ['URLFilter']['Enable']['_value'];
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
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        getURLFilter();
      } else {
        ToastUtils.error('Task Failed');
      }
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

// 添加
  getURLAdd() async {
    try {
      var sn = await sharedGetData('deviceSn', String);
      setState(() {
        loading = true;
        sn = sn.toString();
      });
      // 添加list
      var objectName = "InternetGatewayDevice.WEB_GUI.Security.URLFilter.List";
      var name = 'addObject';
      await Request().addOrDeleteObject(objectName, sn, name);

      // 获取list最新index
      var idParameterNames = [
        'InternetGatewayDevice.WEB_GUI.Security.URLFilter'
      ];
      var urlIdPonse = await Request().getACSNode(idParameterNames, sn);
      var idjsonObj = jsonDecode(urlIdPonse);
      var cpeInfoIndex = '';
      var portsList = idjsonObj['data']['InternetGatewayDevice']['WEB_GUI']
          ['Security']['URLFilter']['List'];
      portsList.keys.forEach((item) {
        // 识别数字属性
        if (RegExp(r'[0-9]+').hasMatch(item)) {
          cpeInfoIndex = item;
        }
      });
      // 设置url
      var parameterNames = [
        [
          "InternetGatewayDevice.WEB_GUI.Security.URLFilter.List.$cpeInfoIndex.URL",
          url,
          'xsd:string'
        ],
      ];
      await Request().setACSNode(parameterNames, sn);
      getURLFilter();
    } catch (e) {
      debugPrint('获取 失败：${e.toString()}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

// 删除
  getURLDel() async {
    var sn = await sharedGetData('deviceSn', String);
    setState(() {
      // loading = true;
      sn = sn.toString();
    });
    var objectName =
        "InternetGatewayDevice.WEB_GUI.Security.URLFilter.List.$id";
    var name = 'deleteObject';
    var response = await Request().addOrDeleteObject(objectName, sn, name);
    try {
      var jsonObj = jsonDecode(response);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        getURLFilter();
      } else {
        ToastUtils.error('Task Failed');
      }
    } catch (e) {
      // loading = false;
      debugPrint('获取设备信息失败：${e.toString()}');
    }
  }

// 修改enable
  editEnable() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.Security.URLFilter.Enable",
        isCheck,
        'xsd:boolean'
      ],
    ];
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
        getURLFilter();
      } else {
        ToastUtils.error('Task Failed');
      }
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            // 自定义返回按钮的回调
            Navigator.pop(context);
          },
        ),
        title: const Text('Website Blocklist',
            style: TextStyle(
              color: Colors.black87,
            )),
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
          : SingleChildScrollView(
              child: GestureDetector(
                onTap: () => closeKeyboard(context),
                child: Column(children: [
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
                                editEnable();
                              });
                            },
                          ),
                        ]),
                  ),
                  SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => closeKeyboard(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 248, 248, 248),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 8),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Select which apps can access the Internet.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(136, 135, 135, 1)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: CheckboxListTile(
                              title: const Text('Select all'),
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                  // 当Checkbox的选中状态改变时，将ListView中每个CheckboxListTile的选中状态也改变
                                  setAllCheckBoxes(value);
                                });
                              },
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 16, top: 8, bottom: 8),
                            child: Text(
                              'Popular apps',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
                            child: Container(
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
                                              value: selected1[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  selected1[index] = value!;
                                                });
                                                updateAllCheckBoxes();
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
                                  style: TextStyle(
                                      color: Color.fromRGBO(136, 135, 135, 1)),
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
                                                _showSnackBar(context,
                                                    'Feedback is successful!');
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
                  ),
                  // 列表
                  // Expanded(
                  //   child: Container(
                  //     height: 1.sh - 70,
                  //     padding: const EdgeInsets.all(5.0),
                  //     child: _itemTextList.isNotEmpty
                  //         ? ListView.builder(
                  //             padding: const EdgeInsets.all(10),
                  //             itemCount: _itemTextList.length,
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //                 child: ListTile(
                  //                   title: Text(
                  //                       jsonDecode(_itemTextList[index])['value']),
                  //                   //删除
                  //                   trailing: IconButton(
                  //                     icon: const Icon(Icons.delete,
                  //                         color: Colors.red),
                  //                     onPressed: () {
                  //                       showDialog(
                  //                         context: context,
                  //                         builder: (BuildContext context) {
                  //                           return AlertDialog(
                  //                             title: Text(S.current.hint),
                  //                             content: Text(S.current.delPro),
                  //                             actions: <Widget>[
                  //                               TextButton(
                  //                                 child: Text(S.current.cancel),
                  //                                 onPressed: () {
                  //                                   Navigator.of(context).pop();
                  //                                 },
                  //                               ),
                  //                               TextButton(
                  //                                 child: const Text('ok'),
                  //                                 onPressed: () {
                  //                                   setState(() {
                  //                                     id = int.parse(jsonDecode(
                  //                                             _itemTextList[index])[
                  //                                         'id']);
                  //                                     getURLDel();
                  //                                   });
                  //                                   Navigator.of(context).pop();
                  //                                 },
                  //                               ),
                  //                             ],
                  //                           );
                  //                         },
                  //                       );
                  //                     },
                  //                   ),
                  //                   // 修改
                  //                   onTap: () {
                  //                     editUrlController.text =
                  //                         jsonDecode(_itemTextList[index])['value'];
                  //                     // 在这里显示弹窗
                  //                     showDialog(
                  //                       context: context,
                  //                       builder: (BuildContext context) {
                  //                         return AlertDialog(
                  //                           title: const Text('Edit'),
                  //                           content: Column(
                  //                             mainAxisSize: MainAxisSize.min,
                  //                             children: <Widget>[
                  //                               TextField(
                  //                                 controller: editUrlController,
                  //                                 decoration: const InputDecoration(
                  //                                   labelText: 'URL',
                  //                                 ),
                  //                                 onChanged: (value) {
                  //                                   url = value;
                  //                                 },
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           actions: <Widget>[
                  //                             TextButton(
                  //                               child: Text(S.current.cancel),
                  //                               onPressed: () {
                  //                                 Navigator.of(context).pop();
                  //                               },
                  //                             ),
                  //                             ElevatedButton(
                  //                               child: Text(S.current.confirm),
                  //                               onPressed: () {
                  //                                 // 在这里处理确定按钮的逻辑
                  //                                 if (checkURL(url)) {
                  //                                   var indexVal = jsonDecode(
                  //                                       _itemTextList[index])['id'];
                  //                                   // 设置
                  //                                   setUrlData(indexVal, url);
                  //                                   // URL格式正确
                  //                                   Navigator.of(context).pop();
                  //                                 } else {
                  //                                   // URL格式错误，弹出提示框
                  //                                   showDialog(
                  //                                     context: context,
                  //                                     builder:
                  //                                         (BuildContext context) {
                  //                                       return AlertDialog(
                  //                                         title:
                  //                                             const Text('Error'),
                  //                                         content: const Text(
                  //                                             'Invalid URL'),
                  //                                         actions: <Widget>[
                  //                                           TextButton(
                  //                                             child:
                  //                                                 const Text('ok'),
                  //                                             onPressed: () {
                  //                                               Navigator.of(
                  //                                                       context)
                  //                                                   .pop();
                  //                                             },
                  //                                           ),
                  //                                         ],
                  //                                       );
                  //                                     },
                  //                                   );
                  //                                 }
                  //                               },
                  //                             ),
                  //                           ],
                  //                         );
                  //                       },
                  //                     );
                  //                   },
                  //                 ),
                  //               );
                  //             },
                  //           )
                  // : const Center(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(
                  //           Icons.content_paste,
                  //           size: 30,
                  //         ),
                  //         SizedBox(width: 10),
                  //         Text('No URLs'),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // ),

                  // + 按钮
                  // SizedBox(
                  //   width: 1.sw,
                  //   child: Center(
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //         fixedSize:
                  //             MaterialStateProperty.all(const Size(150, 35)),
                  //         backgroundColor: MaterialStateProperty.all(
                  //             const Color(0xffffffff)), //背景颜色
                  //         foregroundColor: MaterialStateProperty.all(
                  //             const Color(0xff5E6573)), //字体颜色
                  //         overlayColor: MaterialStateProperty.all(
                  //             const Color(0xffffffff)), // 高亮色
                  //         shadowColor: MaterialStateProperty.all(
                  //             const Color(0xffffffff)), //阴影颜色
                  //         elevation: MaterialStateProperty.all(0), //阴影值
                  //         textStyle: MaterialStateProperty.all(
                  //             const TextStyle(fontSize: 12)), //字体
                  //         side: MaterialStateProperty.all(const BorderSide(
                  //             width: 1, color: Color(0xffCAD0DB))), //边框
                  //         shape: MaterialStateProperty.all(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //         ), //圆角弧度
                  //       ),
                  //       onPressed: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               title: const Text('Add'),
                  //               content: Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: <Widget>[
                  //                   TextField(
                  //                     decoration: const InputDecoration(
                  //                       labelText: 'URL',
                  //                       hintText: 'https://example.com',
                  //                     ),
                  //                     onChanged: (value) {
                  //                       url = value;
                  //                     },
                  //                   ),
                  //                 ],
                  //               ),
                  //               actions: <Widget>[
                  //                 TextButton(
                  //                   child: Text(S.current.cancel),
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                 ),
                  //                 ElevatedButton(
                  //                   child: Text(S.current.confirm),
                  //                   onPressed: () {
                  //                     // 在这里处理确定按钮的逻辑
                  //                     if (checkURL(url)) {
                  //                       getURLAdd();
                  //                       // URL格式正确
                  //                       Navigator.of(context).pop();
                  //                     } else {
                  //                       // URL格式错误，弹出提示框
                  //                       showDialog(
                  //                         context: context,
                  //                         builder: (BuildContext context) {
                  //                           return AlertDialog(
                  //                             title: const Text('Error'),
                  //                             content:
                  //                                 const Text('Invalid URL'),
                  //                             actions: <Widget>[
                  //                               TextButton(
                  //                                 child: const Text('ok'),
                  //                                 onPressed: () {
                  //                                   Navigator.of(context).pop();
                  //                                 },
                  //                               ),
                  //                             ],
                  //                           );
                  //                         },
                  //                       );
                  //                     }
                  //                   },
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //       child: Text("Add",
                  //           style:
                  //               TextStyle(fontSize: 30.sp, color: Colors.blue)),
                  //     ),
                  //   ),
                  // ),
                ]),
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
