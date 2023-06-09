import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/custom_app_bar.dart';

/// Internet
class Internet extends StatefulWidget {
  const Internet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InternetState();
}

class _InternetState extends State<Internet> {
  //选择日期
  String date = 'Yesterday';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Internet usage '),
        body: Container(
          padding: EdgeInsets.all(26.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Yesterday
                  TextButton(
                    onPressed: () {
                      setState(() {
                        date = 'Yesterday';
                      });
                    },
                    child: Text(
                      'Yesterday',
                      style: TextStyle(
                          color: date == 'Yesterday'
                              ? Colors.blue
                              : Colors.black54),
                    ),
                  ),
                  //Today
                  TextButton(
                    onPressed: () {
                      setState(() {
                        date = 'Today';
                      });
                    },
                    child: Text(
                      'Today',
                      style: TextStyle(
                          color:
                              date == 'Today' ? Colors.blue : Colors.black54),
                    ),
                  ),
                  //Last  7 days
                  TextButton(
                    onPressed: () {
                      setState(() {
                        date = 'Lastdays';
                      });
                    },
                    child: Text(
                      'Last  7 days',
                      style: TextStyle(
                          color: date == 'Lastdays'
                              ? Colors.blue
                              : Colors.black54),
                    ),
                  ),
                ],
              ),
              if (date == 'Yesterday')
                const Image(image: AssetImage('assets/images/yeterday.png')),
              if (date == 'Today')
                const Image(image: AssetImage('assets/images/today.png')),
              if (date == 'Lastdays')
                const Image(image: AssetImage('assets/images/last7day.png'))
              // Image(
              //     image: date == 'Yesterday'
              //         ? AssetImage('assets/images/Yesterday.png')
              //         : AssetImage('assets/images/Today.png')),
              // : AssetImage('assets/images/Last7days.png'),
            ],
          )),
        ));
  }
}
