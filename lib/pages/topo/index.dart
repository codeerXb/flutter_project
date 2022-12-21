import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
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
    getTopoData();
  }

  void getTopoData() {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["OnlineDeviceTable"]',
    };
    XHttp.get('/data.html', data).then((res) {
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
      debugPrint('获取在线设备失败：${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool MESH = true;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('网络拓扑'),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              //刷新
              getTopoData();
            },
            icon: const Icon(Icons.refresh)),
        actions: [
          IconButton(
              onPressed: () {
                // 占位
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 96.w,
                    width: 96.w,
                    // margin: const EdgeInsets.only(top: 20, bottom: 5),
                    child: ClipOval(
                        child: Image.network(
                            "http://imgsrc.baidu.com/forum/w=580/sign=ae2a4e35ba19ebc4c0787691b226cf79/5e13af1c8701a18b50cd631f972f07082938fe80.jpg",
                            fit: BoxFit.cover)),
                  ),
                  Text(
                    'Internet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  Container(
                    height: 92.w,
                    width: 24.w,
                    margin: const EdgeInsets.all(5),
                    child: Image.network(
                        'https://z4a.net/images/2022/12/06/shu.jpg',
                        fit: BoxFit.fill),
                  ),
                ],
              ),
              Container(
                height: 56.w,
                width: 200.w,
                margin: const EdgeInsets.all(5),
                child: Image.network(
                    'https://z4a.net/images/2022/12/12/odu.jpg',
                    fit: BoxFit.fill),
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
                          height: 96.w,
                          width: 96.w,
                          margin: const EdgeInsets.all(5),
                          child: Image.network(
                              'https://img.redocn.com/sheying/20200324/shujiashangdeshuji_10870699.jpg',
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 94, 164, 245),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            height: 32.w,
                            width: 32.w,
                            child: Text(
                              meshData.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                        ),
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
                  Center(
                    child: Container(
                      height: 76.w,
                      width: 24.w,
                      margin: const EdgeInsets.all(5),
                      child: Image.network(
                          'https://z4a.net/images/2022/12/06/shu.jpg',
                          fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), width: 0.5),
              borderRadius: BorderRadius.circular((5.0)),
            ),
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 130.w,
                    width: 130.w,
                    margin: const EdgeInsets.all(5),
                    child: Image.network(
                        'https://z4a.net/images/2022/12/12/wifi.jpg',
                        fit: BoxFit.fill),
                  ),
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 22,
                  childAspectRatio: 1.0,
                  children: meshData
                      .map(
                        (e) => MESHItem(
                          title: e.title,
                          isNative: e.isNative,
                          isShow: e.isShow,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'MESH组网',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 96.w,
              width: MediaQuery.of(context).size.width - 74,
              margin:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 37, right: 37),
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
    );
  }
}
