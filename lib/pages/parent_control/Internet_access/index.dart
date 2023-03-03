import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/custom_app_bar.dart';

/// Internetaccess access time managemen
class Internetaccess extends StatefulWidget {
  const Internetaccess({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InternetaccessState();
}

class _InternetaccessState extends State<Internetaccess> {
  //选择日期
  String date = 'timePeriod';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context, title: 'Internet access time managemen '),
        body: Container(
          padding: EdgeInsets.all(26.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //time period
                  TextButton(
                    onPressed: () {
                      setState(() {
                        date = 'timePeriod';
                      });
                    },
                    child: Text(
                      'time period',
                      style: TextStyle(
                          color: date == 'timePeriod'
                              ? Colors.blue
                              : Colors.black54),
                    ),
                  ),
                  //duration
                  TextButton(
                    onPressed: () {
                      setState(() {
                        date = 'duration';
                      });
                    },
                    child: Text(
                      'Duration',
                      style: TextStyle(
                          color: date == 'duration'
                              ? Colors.blue
                              : Colors.black54),
                    ),
                  ),
                ],
              ),
              if (date == 'timePeriod')
                Image(image: AssetImage('assets/images/timePeriod.png')),
              if (date == 'duration')
                Image(image: AssetImage('assets/images/duration.png')),
            ],
          )),
        ));
  }
}
