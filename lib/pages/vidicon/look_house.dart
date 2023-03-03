// 看家
import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';

class LookHouse extends StatefulWidget {
  const LookHouse({super.key});

  @override
  State<LookHouse> createState() => _LookHouseState();
}

class _LookHouseState extends State<LookHouse> {
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
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Home surveillance'),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => closeKeyboard(context),
            child: const Image(
              image: AssetImage('assets/images/lookhouse.png'),
            ),
          ),
        ));
  }
}
