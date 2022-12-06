import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 常见问题
class CommonProblem extends StatefulWidget {
  const CommonProblem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommonProblemState();
}

class _CommonProblemState extends State<CommonProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '常见问题'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: problemListWidget(),
          ),
        ),
      ),
    );
  }

  List<Widget> problemListWidget() {
    List<Widget> list = [];
    list.add(CommonWidget.simpleWidgetWithUserDetail("如何切换用户？", callBack: () {
      print("如何切换用户");
    }));
    list.add(CommonWidget.simpleWidgetWithUserDetail("如何修改密码？", callBack: () {
      print("如何修改密码");
    }));
    list.add(CommonWidget.simpleWidgetWithUserDetail("如何找回密码？", callBack: () {
      print("如何找回密码");
    }));
    list.add(CommonWidget.simpleWidgetWithUserDetail("如何更新系统？", callBack: () {
      print("如何更新系统");
    }));
    return list;
  }
}
