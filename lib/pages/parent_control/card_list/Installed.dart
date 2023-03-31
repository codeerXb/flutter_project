import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Installed extends StatefulWidget {
  const Installed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InstalledState();
}

class _InstalledState extends State<Installed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Installed'),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: const SingleChildScrollView(
            child: Image(
              image: AssetImage('assets/images/Installed.png'),
            ),
          ),
        ));
  }
}
