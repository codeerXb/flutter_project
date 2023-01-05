import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:flutter_template/pages/topo/mesh_item.dart';
import 'package:get/get.dart';

import 'topo_data.dart';
import 'topo_item.dart';

//网络拓扑
class Topo extends StatefulWidget {
  const Topo({Key? key}) : super(key: key);

  @override
  State<Topo> createState() => _TopoState();
}

class _TopoState extends State<Topo> {
  EquipmentDatas topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
  @override
  void initState() {
    super.initState();
    updateStatus();
    getTopoData(false);
  }

  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接
  String _wifiStatus = '0';
  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';

  /// 获取网络连接状态和上下行速率并更新
  void updateStatus() async {
    Map<String, dynamic> netStatus = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectionStatus","systemDataRateDlCurrent","systemDataRateUlCurrent","wifiHaveOrNot","wifi5gHaveOrNot","wifiEnable","wifi5gEnable","lteRoam"]'
    };
    try {
      var response = await XHttp.get('/data.html', netStatus);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(response)) {
        setState(() {
          _wanStatus = '0';
          _wifiStatus = '0';
          _simStatus = '0';
        });
        debugPrint('netStatus得到数据不是json');
      }
      var resObj = NetConnecStatus.fromJson(json.decode(response));
      String wanStatus = resObj.ethernetConnectionStatus == '1' ? '1' : '0';
      String wifiStatus =
          (resObj.wifiHaveOrNot == '1' || resObj.wifi5gHaveOrNot == '1')
              ? '1'
              : '0';
      String simStatus = resObj.lteRoam == '1' ? '1' : '0';
      setState(() {
        _wanStatus = wanStatus;
        _wifiStatus = wifiStatus;
        _simStatus = simStatus;
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void getTopoData(sx) {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["OnlineDeviceTable"]',
    };
    XHttp.get('/data.html', data).then((res) {
      if (sx) {
        ToastUtils.toast('刷新成功');
      }
      try {
        debugPrint("\n================== 获取在线设备 ==========================");
        var d = json.decode(res.toString());
        setState(() {
          topoData = EquipmentDatas.fromJson(d);
        });
      } on FormatException catch (e) {
        setState(() {
          topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
        });
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      ToastUtils.toast('获取在线设备失败');
      debugPrint('获取在线设备失败：${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool MESH = true;
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xfff5f6fa),
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/topbj.png'),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('网络拓扑'),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                //刷新
                getTopoData(true);
              },
              icon: const Icon(Icons.refresh)),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // 占位
          //       },
          //       icon: const Icon(Icons.settings))
          // ],
        ),
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 96.w,
                  width: 96.w,
                  // margin: const EdgeInsets.only(top: 20, bottom: 5),
                  child: ClipOval(
                      child: Image.network(
                          "https://bpic.51yuansu.com/pic3/cover/03/10/19/5b46a61d01fc0_610.jpg",
                          fit: BoxFit.cover)),
                ),
                Text(
                  'Internet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                Stack(children: [
                  Container(
                    height: 92.w,
                    width: 24.w,
                    margin: const EdgeInsets.all(5),
                    child: Image.network(
                        'https://z4a.net/images/2022/12/06/shu.jpg',
                        fit: BoxFit.fill),
                  ),
                  if (_wanStatus == '0' && _simStatus == '0')
                    Positioned(
                      top: 40.w,
                      left: 4.w,
                      child: Icon(
                        Icons.close,
                        color: const Color.fromARGB(255, 206, 47, 47),
                        size: 32.w,
                      ),
                    )
                ])
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: (() {
                    Get.toNamed("/odu");
                  }),
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        height: 196.w,
                        width: 196.w,
                        margin: const EdgeInsets.all(5),
                        child: Image.asset('assets/images/odu.png',
                            fit: BoxFit.cover),
                      ),
                      // Positioned(
                      //   right: 0,
                      //   top: 0,
                      //   child: Container(
                      //     decoration: const BoxDecoration(
                      //       color: Color.fromARGB(255, 94, 164, 245),
                      //       borderRadius: BorderRadius.all(Radius.circular(8)),
                      //     ),
                      //     height: 32.w,
                      //     width: 32.w,
                      //     child: Text(
                      //       meshData.length.toString(),
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 24.sp,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Text(
                  'ODU',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                Stack(children: [
                  Container(
                    height: 92.w,
                    width: 24.w,
                    margin: const EdgeInsets.all(5),
                    child: Image.network(
                        'https://z4a.net/images/2022/12/06/shu.jpg',
                        fit: BoxFit.fill),
                  ),
                  // Positioned(
                  //   top: 40.w,
                  //   left: 14.w,
                  //   child: const Text("x"),
                  // )
                ])
              ],
            ),
            Center(
              child: Container(
                height: 130.w,
                width: 130.w,
                margin: const EdgeInsets.all(5),
                child: Image.network(
                    'https://pic.ntimg.cn/file/20170811/10673188_150225172000_2.jpg',
                    fit: BoxFit.fill),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //         color: const Color.fromARGB(255, 0, 0, 0), width: 0.5),
            //     borderRadius: BorderRadius.circular((5.0)),
            //   ),
            //   margin: const EdgeInsets.all(15),
            //   child: Column(
            //     children: [
            //       Center(
            //         child: Container(
            //           height: 130.w,
            //           width: 130.w,
            //           margin: const EdgeInsets.all(5),
            //           child: Image.network(
            //               'https://z4a.net/images/2022/12/12/wifi.jpg',
            //               fit: BoxFit.fill),
            //         ),
            //       ),
            //       GridView.count(
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         crossAxisCount: 4,
            //         mainAxisSpacing: 22,
            //         childAspectRatio: 1.0,
            //         children: meshData
            //             .map(
            //               (e) => MESHItem(
            //                 title: e.title,
            //                 isNative: e.isNative,
            //                 isShow: e.isShow,
            //               ),
            //             )
            //             .toList(),
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Container(
                height: 96.w,
                width: MediaQuery.of(context).size.width - 74,
                margin: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 37, right: 37),
                child: Image.network('https://z4a.net/images/2022/12/06/22.jpg',
                    height: 96.w,
                    width: MediaQuery.of(context).size.width - 74,
                    fit: BoxFit.fill),
              ),
            ),
            if (topoData.onlineDeviceTable!.isNotEmpty)
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                children: topoData.onlineDeviceTable!
                    .map(
                      (e) => TopoItem(
                        title: e.hostName!,
                        isNative: false,
                        isShow: true,
                        topoData: e,
                      ),
                    )
                    .toList(),
              ),
            if (!topoData.onlineDeviceTable!.isNotEmpty)
              Center(
                child: Container(
                    margin: EdgeInsets.only(top: 100.sp),
                    height: 200.w,
                    child: const Text('暂无设备连接')),
              )
          ],
        ),
      ),
    );
  }
}
