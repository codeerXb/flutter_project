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

class Blocklist extends StatefulWidget {
  const Blocklist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocklistState();
}

class _BlocklistState extends State<Blocklist> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  dynamic mac = Get.arguments['mac'];
  dynamic sn = Get.arguments['sn'];
  dynamic formParam = ''; //传输给后台的param

  bool? allChecked = true; // 全选

  final TextEditingController _textEditingController = TextEditingController();

  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Google.jpg',
      'text': 'Google',
      'code': '8001',
      'select': true,
    },
    {
      'img': 'assets/images/TikTok.jpg',
      'text': 'Wiki',
      'code': '8002',
      'select': true,
    },
    {
      'img': 'assets/images/Yahoo.jpg',
      'text': 'Yahoo',
      'code': '8003',
      'select': true,
    },
    {
      'img': 'assets/images/Apple.jpg',
      'text': 'Apple',
      'code': '8004',
      'select': true,
    },
    {
      'img': 'assets/images/Reddit.jpg',
      'text': 'Reddit',
      'code': '8010',
      'select': true,
    },
    {
      'img': 'assets/images/Outlook.jpg',
      'text': 'Outlook',
      'code': '8011',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Naver',
      'code': '8012',
      'select': true,
    },
    {
      'img': 'assets/images/Fandom.jpg',
      'text': 'Fandom',
      'code': '8013',
      'select': true,
    },
    {
      'img': 'assets/images/Globo.jpg',
      'text': 'Globo',
      'code': '8015',
      'select': true,
    },
    {
      'img': 'assets/images/Yelp.jpg',
      'text': 'Yelp',
      'code': '8016',
      'select': true,
    },
    {
      'img': 'assets/images/Pinterest.jpg',
      'text': 'Pinterest',
      'code': '8017',
      'select': true,
    },
    {
      'img': 'assets/images/BBC.jpg',
      'text': 'BBC',
      'code': '8018',
      'select': true,
    },
    {
      'img': 'assets/images/Linkedin.jpg',
      'text': 'Linkedin',
      'code': '8020',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Merriam-webster',
      'code': '8022',
      'select': true,
    },
    {
      'img': 'assets/images/Dictionary.jpg',
      'text': 'Dictionary',
      'code': '8027',
      'select': true,
    },
    {
      'img': 'assets/images/Tripadvisor.jpg',
      'text': 'Tripadvisor',
      'code': '8028',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Britannica',
      'code': '8029',
      'select': true,
    },
    {
      'img': 'assets/images/Cambridge.jpg',
      'text': 'Cambridge',
      'code': '8030',
      'select': true,
    },
    {
      'img': 'assets/images/Weather.jpg',
      'text': 'Weather',
      'code': '8032',
      'select': true,
    },
    {
      'img': 'assets/images/Wiktionary.jpg',
      'text': 'Wiktionary',
      'code': '8033',
      'select': true,
    },
    {
      'img': 'assets/images/Espn.jpg',
      'text': 'Espn',
      'code': '8034',
      'select': true,
    },
    {
      'img': 'assets/images/Microsoft.jpg',
      'text': 'Microsoft',
      'code': '8035',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Gsmarena',
      'code': '8038',
      'select': true,
    },
    {
      'img': 'assets/images/Webmd.jpg',
      'text': 'Webmd',
      'code': '8039',
      'select': true,
    },
    {
      'img': 'assets/images/Craigslist.jpg',
      'text': 'Craigslist',
      'code': '8040',
      'select': true,
    },
    {
      'img': 'assets/images/Cricbuzz.jpg',
      'text': 'Cricbuzz',
      'code': '8041',
      'select': true,
    },
    {
      'img': 'assets/images/Mayoclinic.jpg',
      'text': 'Mayoclinic',
      'code': '8042',
      'select': true,
    },
    {
      'img': 'assets/images/Timeanddate.jpg',
      'text': 'Timeanddate',
      'code': '8043',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Espncricinfo',
      'code': '8044',
      'select': true,
    },
    {
      'img': 'assets/images/Healthline.jpg',
      'text': 'Healthline',
      'code': '8045',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Rottentomatoes',
      'code': '8047',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Thefreedictionary',
      'code': '8049',
      'select': true,
    },
    {
      'img': 'assets/images/Bestbuy.jpg',
      'text': 'Bestbuy',
      'code': '8052',
      'select': true,
    },
    {
      'img': 'assets/images/Indeed.jpg',
      'text': 'Indeed',
      'code': '8053',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Samsung',
      'code': '8058',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Investopedia',
      'code': '8059',
      'select': true,
    },
    {
      'img': 'assets/images/Flashscore.jpg',
      'text': 'Flashscore',
      'code': '8060',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Steampowered',
      'code': '8061',
      'select': true,
    },
    {
      'img': 'assets/images/Roblox.jpg',
      'text': 'Roblox',
      'code': '8064',
      'select': true,
    },
    {
      'img': 'assets/images/Nordstrom.jpg',
      'text': 'Nordstrom',
      'code': '8065',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Thepiratebay',
      'code': '8066',
      'select': true,
    },
    {
      'img': 'assets/images/Indiatimes.jpg',
      'text': 'Indiatimes',
      'code': '8067',
      'select': true,
    },
    {
      'img': 'assets/images/Cnbc.jpg',
      'text': 'Cnbc',
      'code': '8068',
      'select': true,
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Ssyoutube',
      'code': '8069',
      'select': true,
    },
    {
      'img': 'assets/images/Adobe.jpg',
      'text': 'Adobe',
      'code': '8070',
      'select': true,
    },
    {
      'img': 'assets/images/Speedtest.jpg',
      'text': 'Speedtest',
      'code': '8071',
      'select': true,
    },
    {
      'img': 'assets/images/Lowes.jpg',
      'text': 'Lowes',
      'code': '8072',
      'select': true,
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

  bool _isLoading = false;
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });

    formParam['rules']['websiteapps'] = '';
    for (var element in topData) {
      if (element['select'] == true) {
        formParam['rules']['websiteapps'] += element['code'] + ' ';
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
        //遍历白名单列表
        d['data']['rules']['websiteapps'].split(' ').forEach((item) {
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
    getParentControlConfigFn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: customAppbar(
            context: context,
            title: 'Website Streaming',
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
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text(
                    'Popular apps',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
                  child: SingleChildScrollView(
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
