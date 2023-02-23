// 存储管理
import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';

class AtorageAdministration extends StatefulWidget {
  const AtorageAdministration({super.key});

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
    return Scaffold(
      appBar: customAppbar(context: context, title: '存储管理'),
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () => closeKeyboard(context),
          child: const Image(
            image: AssetImage('assets/images/storageadministration.png'),
            width: 390,
            height: 700,
          ),
        ),
      ),
    );
  }
}
