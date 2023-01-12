import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 访客网络
class VisitorNet extends StatefulWidget {
  const VisitorNet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VisitorNetState();
}

class _VisitorNetState extends State<VisitorNet> {
  bool show1 = false;
  List<dynamic> arr_2 = [1, 2, 3];
  dynamic i = 1;
  List<dynamic> arr_5 = [4,5,6];
  dynamic j = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '访客网络'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleWidger(title: '2.4GHZ' + arr_2.toString()),
                //添加按钮
                Offstage(
                  offstage: arr_2.length == 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {
                        setState(() {
                          arr_2.add(i);
                          i++;
                          // if ([1, 2, 3].contains(i)) {
                          // }
                        });
                      },
                      child: Text(
                        '添加',
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  ),
                ),
                //访客
                Offstage(
                  offstage: !arr_2.contains(1),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest1',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_2.remove(1);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_one");
                      }),
                ),
                Offstage(
                  offstage: !arr_2.contains(2),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest2',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_2.remove(2);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_two");
                      }),
                ),
                Offstage(
                  offstage: !arr_2.contains(3),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest3',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_2.remove(3);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_three");
                      }),
                ),
                TitleWidger(title: '5GHZ' + arr_5.toString()),
                //添加按钮
                Offstage(
                  offstage: arr_5.length == 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {
                        setState(() {
                          arr_5.add(i);
                          i++;
                        });
                      },
                      child: Text(
                        '添加',
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  ),
                ),
                //访客
                Offstage(
                  offstage: !arr_5.contains(4),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest4',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_5.remove(4);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_four");
                      }),
                ),
                Offstage(
                  offstage: !arr_5.contains(5),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest5',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_5.remove(5);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_five");
                      }),
                ),
                Offstage(
                  offstage: !arr_5.contains(6),
                  child: CommonWidget.simpleWidgetWithMine(
                      title: 'guest6',
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            arr_5.remove(6);
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                      callBack: () {
                        Get.toNamed("/visitor_six");
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
