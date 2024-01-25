import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'dart:convert';
import 'dart:async';
import './beans/scan_quality_bean.dart';
import 'package:get/get.dart';

class AdvanceChannelListPage extends StatefulWidget {
  const AdvanceChannelListPage({super.key});

  @override
  State<AdvanceChannelListPage> createState() => _AdvanceChannelListPageState();
}

class _AdvanceChannelListPageState extends State<AdvanceChannelListPage> {
  List<Band5GHz> listArray = [];
  String currentChannnel = "";
  String bastChannel = "";
  String sn = "";
  bool isLoaded = true;
  Timer? timer;
  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint('deviceSn : $res');
      sn = res.toString();
      // getCurrentChannnel();
    }));
    setState(() {
      listArray = Get.arguments["data"];
      currentChannnel = Get.arguments["currentChannel"];
      bastChannel = listArray[0].channel!;
    });

    super.initState();
  }

  /// 获取当前的信道
  Future getCurrentChannnel() async {
    // 获取SOD节点数据
    var parameterNames = {
      "method": "get",
      "nodes": ["wifi5gCurrentChannel"]
    };

    var res = await Request().getACSNode(parameterNames, sn);
    var jsonObj = jsonDecode(res);
    var currentChannelRes = jsonObj["data"]["wifi5gCurrentChannel"];
    setState(() {
      currentChannnel = currentChannelRes;
    });
    debugPrint('当前的信道是:----$jsonObj----}');
  }

  /// 设置最优信道
  Future<int> setUpBastChannnel() async {
    var parameters = {
      "method": "set",
      "nodes": {"wifi5gChannel": bastChannel}
    };
    var res = await Request().setACSNode(parameters, sn);
    var jsonObj = jsonDecode(res);
    debugPrint('返回的配置结果是:----$jsonObj----}');
    return jsonObj["code"];
  }

  getChannelResult() {
    setUpBastChannnel().then((res) {
      if (res == 200) {
        timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
          getDeviceRestratResult().then((value) {
            if (value == "0") {
              timer.cancel();
              getCurrentChannnel();
              setState(() {
                isLoaded = true;
              });
            }
          });
        });
      }
    });
  }

  Future<String> getDeviceRestratResult() async {
    var parameterNames = {
      "method": "get",
      "nodes": ["wifi5gIsRestart"]
    };

    var res = await Request().getACSNode(parameterNames, sn);
    var jsonObj = jsonDecode(res);
    var restartRes = jsonObj["data"]["wifi5gIsRestart"];
    debugPrint('当前的结果是:----$restartRes----}');
    return restartRes;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back(result: currentChannnel);
            },
          ),
          title: const Text(
            "WiFi Quality",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: isLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      // flex: 4,
                      child: ListView.builder(
                          itemCount: listArray.length,
                          itemBuilder: (BuildContext context, int index) {
                            return setListItem(listArray[index]);
                          })),
                  Container(
                    width: double.infinity,
                    height: 100,
                    alignment: Alignment.topCenter,
                    child: OutlinedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          setState(() {
                            isLoaded = false;
                            getChannelResult();
                          });
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                  )
                ],
              )
            : showLoadingIndicator());
  }

  Widget setListItem(Band5GHz model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "${model.channel}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                value: double.parse(model.quality!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              currentChannnel == model.channel ? "now" : "",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget showLoadingIndicator() {
    return Offstage(
      offstage: isLoaded,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              animating: true,
              radius: 20,
              color: Colors.grey,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Optimizing, please wait",
              style: TextStyle(fontSize: 15, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
