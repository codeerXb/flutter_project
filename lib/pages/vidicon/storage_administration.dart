// 存储管理
import 'package:flutter/material.dart';

class AtorageAdministration extends StatefulWidget {
  const AtorageAdministration({Key? key}) : super(key: key);

  @override
  State<AtorageAdministration> createState() => _AtorageAdministrationState();
}

class _AtorageAdministrationState extends State<AtorageAdministration> {
  @override
  void initState() {
    super.initState();
    // getDnsData();
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: "云存"),
                  Tab(text: "本地"),
                  Tab(text: "SD卡")
                ],
              ),
            ),
            body: TabBarView(children: <Widget>[
              ListView(
                children: const <Widget>[
                  ListTile(title: Text("暂未开通")),
                ],
              ),
              ListView(
                children: const <Widget>[
                  ListTile(title: Text("暂未下载")),
                ],
              ),
              InkWell(
                onTap: () => closeKeyboard(context),
                child: const Image(
                  image: AssetImage('assets/images/storageadministration.png'),
                ),
              ),
            ])));
  }
}
