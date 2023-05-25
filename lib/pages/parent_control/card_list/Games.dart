import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Games'),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => closeKeyboard(context),
            child: Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              height: 706,
              child: Column(children: const [
                Image(
                  image: AssetImage('assets/images/games.jpg'),
                ),
              ]),
            ),
          ),
        ));
  }
}
