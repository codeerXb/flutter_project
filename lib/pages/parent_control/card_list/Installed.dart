import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Intsalled extends StatefulWidget {
  const Intsalled({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntsalledState();
}

class _IntsalledState extends State<Intsalled> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Intsalled'),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child:Image(
                  image: AssetImage('assets/images/Installed.png'),
                ),
          ),
        ));
  }
}
