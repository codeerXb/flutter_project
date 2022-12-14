import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// 访客网络
class VisitorNet extends StatefulWidget {
  const VisitorNet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VisitorNetState();
}

class _VisitorNetState extends State<VisitorNet> {
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '访客网络'),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:const [Text('1')],
            ),
          ),
        ));
  }
}
