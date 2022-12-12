import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 静态路由
class StaticRoute extends StatefulWidget {
  const StaticRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StaticRouteState();
}

class _StaticRouteState extends State<StaticRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '静态路由'),
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
    list.add(CommonWidget.simpleWidgetWithUserDetail("静态路由", callBack: () {
      print("静态路由"); //static_route
    }));
    return list;
  }
}
