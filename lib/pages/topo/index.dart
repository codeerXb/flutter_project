import 'package:flutter/material.dart';

import 'topo_data.dart';
import 'topo_item.dart';

//网络拓扑
class Topo extends StatelessWidget {
  const Topo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('网络拓扑'),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              //刷新
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
        children: [
          Center(
            child: Container(
              height: 48,
              width: 48,
              margin: const EdgeInsets.only(top: 20, bottom: 5),
              child: ClipOval(
                  child: Image.network(
                      "http://imgsrc.baidu.com/forum/w=580/sign=ae2a4e35ba19ebc4c0787691b226cf79/5e13af1c8701a18b50cd631f972f07082938fe80.jpg",
                      fit: BoxFit.cover)),
            ),
          ),
          Center(
            child: Container(
              height: 38,
              width: 12,
              margin: const EdgeInsets.all(5),
              child: Image.network('https://z4a.net/images/2022/12/06/shu.jpg',
                  fit: BoxFit.fill),
            ),
          ),
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      height: 64,
                      width: 64,
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        height: 16,
                        width: 16,
                        child: const Text(
                          '6',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width - 74,
              margin:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 37, right: 37),
              child: Image.network('https://z4a.net/images/2022/12/06/22.jpg',
                  height: 48,
                  width: MediaQuery.of(context).size.width - 74,
                  fit: BoxFit.fill),
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            children: topoData
                .map(
                  (e) => TopoItem(
                    title: e.title,
                    isNative: e.isNative,
                    isShow: e.isShow,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}