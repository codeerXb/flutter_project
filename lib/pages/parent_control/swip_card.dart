import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';

import '../../config/base_config.dart';

/// 顶部滑动卡片
class Swipcard extends StatefulWidget {
  const Swipcard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwipcardState();
}

class _SwipcardState extends State<Swipcard> {
  bool loading = true;
  String sn = '';
  bool isEditable = false; //是否编辑
  List deviceList = []; //设备列表
  final List<TextEditingController> _editvalueList = []; //编辑列表

//获取列表
  getDeviceListFn() async {
    var res = await sharedGetData('deviceSn', String);
    setState(() {
      loading = true;
      sn = res.toString();
    });
    var response = await App.post(
        '${BaseConfig.cloudBaseUrl}/cpeMqtt/getDevicesTable',
        data: {'sn': sn, "type": "getDevicesTable"});
    setState(() {
      loading = false;
    });
    var d = json.decode(response.toString());
    setState(() {
      d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
      deviceList = d['data']['wifiDevices'];

      //编辑文字回显
      _editvalueList.addAll(
          deviceList.map((item) => TextEditingController(text: item['name'])));
      print('设备列表$deviceList');
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceListFn();
  }

//重设名称
  editName(String sn, String mac, String nickname) async {
    Map<String, dynamic> form = {
      'sn': sn,
      'mac': mac,
      'nickname': nickname,
    };
    var res = await App.post('${BaseConfig.cloudBaseUrl}/platform/cpeNick/nick',
        data: form);
    var d = json.decode(res.toString());
    if (d['code'] != 200) {
      ToastUtils.error(d['message']);
    } else {
      ToastUtils.success(d['message']);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: deviceList.length > 0 ? 240.w : 0.w,
            child: Swiper(
              onIndexChanged: (int index) {
                print('index233$index');
              },
              itemCount: deviceList.length, // 轮播图数量
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 5, //设置卡片阴影的深度
                  shape: const RoundedRectangleBorder(
                    //设置卡片圆角
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(255, 200, 211, 246),
                          Color.fromARGB(255, 219, 224, 228),
                        ],
                      ),
                    ),
                    child: ListTile(
                      //图片
                      leading: ClipOval(
                          child: Image.asset('assets/images/phone.png',
                              fit: BoxFit.fitWidth, width: 110.w)),
                      //中间文字
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 300.w,
                            child:
                                //编辑
                                // TextField(
                                //     autofocus: true,
                                //     controller: _editvalueList[index],
                                //     maxLines: 1,
                                //     decoration: InputDecoration(
                                //         border: const UnderlineInputBorder(
                                //           borderSide: BorderSide.none,
                                //         ),
                                //         hintText: S.current.enter),
                                //     onChanged: (value) {
                                //       setState(() {
                                //         deviceList[index]['name'] = value;
                                //       });
                                //     },
                                //   )
                                //显示的文字
                                Text(
                              deviceList[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          // 编辑
                          IconButton(
                            onPressed: () {
                              //底部弹出Container
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      Navigator.pop(context);
                                      _editvalueList[index].text =
                                          deviceList[index]['name'];
                                      return false;
                                    },
                                    child: Container(
                                      height: 1100.w,
                                      padding: EdgeInsets.only(
                                        left: 40.w,
                                        right: 40.w,
                                        //将在输入框底部添加一个填充，以确保输入框不会被键盘遮挡。
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 30.w)),

                                          //title
                                          Text(
                                            S.current.ModifyRemarks,
                                            style: TextStyle(fontSize: 46.sp),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 46.w)),

                                          //输入框
                                          TextField(
                                            autofocus: true,
                                            controller: _editvalueList[index],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(left: 20.w),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: S.current.pleaseEnter,
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  // 清空输入框中的内容
                                                  _editvalueList[index].clear();
                                                },
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                deviceList[index]['name'] =
                                                    value;
                                              });
                                            },
                                          ),

                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.w)),
                                          //btn
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //取消
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _editvalueList[index].text =
                                                        deviceList[index]
                                                            ['name'];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(S.current.cancel),
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      Size(300.w, 70.w),
                                                ),
                                              ),
                                              //确定
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_editvalueList[index]
                                                      .text
                                                      .isNotEmpty) {
                                                    isEditable = false;
                                                    editName(
                                                        sn,
                                                        deviceList[index]
                                                            ['MACAddress'],
                                                        deviceList[index]
                                                            ['name']);
                                                  }
                                                },
                                                child: Text(S.current.confirm),
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      Size(300.w, 70.w),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              setState(() {
                                isEditable = true;
                              });
                            },
                            icon: const Icon(Icons.create),
                          )
                          // 确认
                          // IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         if (_editvalueList[index]
                          //             .text
                          //             .isNotEmpty) {
                          //           isEditable = false;
                          //           editName(
                          //               sn,
                          //               deviceList[index]['MACAddress'],
                          //               deviceList[index]['name']);
                          //         }
                          //       });
                          //     },
                          //     icon: const Icon(Icons.check_circle),
                          //   ),
                        ],
                      ),

                      //title下方显示的内容
                      subtitle: Text(
                        deviceList[index]['connection'] == null
                            ? '-'
                            : deviceList[index]['connection'],
                      ),
                    ),
                  ),
                );
              },
              pagination: SwiperPagination(), // 显示分页器
            ),
          );
  }
}
