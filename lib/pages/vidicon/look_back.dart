// 回看
import 'package:flutter/material.dart';

class LookBack extends StatefulWidget {
  const LookBack({Key? key}) : super(key: key);

  @override
  State<LookBack> createState() => _LookBackState();
}

class _LookBackState extends State<LookBack> {
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
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.white,
              centerTitle: true,
              bottom: const TabBar(
                tabs: <Widget>[Tab(text: "云存"), Tab(text: "SD卡")],
              ),
            ),
            body: TabBarView(children: <Widget>[
              ListView(
                children: const <Widget>[
                  ListTile(title: Text("暂未开通")),
                ],
              ),
              InkWell(
                onTap: () => closeKeyboard(context),
                child: const Image(
                  image: AssetImage('assets/images/lookback.png'),
                ),
              ),
            ])));
  }
}
