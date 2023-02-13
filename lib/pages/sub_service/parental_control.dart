import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 家长控制
class Parcontrol extends StatefulWidget {
  const Parcontrol({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParcontrolState();
}

class _ParcontrolState extends State<Parcontrol> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: S.of(context).parentalControl),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //家长控制
                TitleWidger(title: S.of(context).parentalControl),
              ],
            ),
          ),
        ));
  }
}
