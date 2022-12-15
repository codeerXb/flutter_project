import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import '../../core/widget/custom_app_bar.dart';

/// 以太网设置
class NetSet extends StatefulWidget {
  const NetSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetSetState();
}

class _NetSetState extends State<NetSet> {
  String showVal = '动态ip';
  int val = 0;
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '以太网设置'),
        body: Container(
          padding: EdgeInsets.all(20.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 2000.h,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '设置'),

                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //连接模式
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('连接模式',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: ['动态ip', '静态ip', 'LAN Only'],
                                value: val,
                              );
                              result?.then((selectedValue) => {
                                    if (val != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              val = selectedValue,
                                              showVal = [
                                                '动态ip',
                                                '静态ip',
                                                'LAN Only'
                                              ][val]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(showVal,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 14)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //仅以太网
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('仅以太网',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Row(
                            children: [
                              Switch(
                                value: isCheck,
                                onChanged: (newVal) {
                                  setState(() {
                                    isCheck = newVal;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    //MTU
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('MTU',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          SizedBox(
                            width: 300.w,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 26.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                hintText: "输入MTU",
                                hintStyle: TextStyle(
                                    fontSize: 26.sp,
                                    color: const Color(0xff737A83)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //检测服务器
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('检测服务器',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          SizedBox(
                            width: 300.w,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 26.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                hintText: "输入检测服务器",
                                hintStyle: TextStyle(
                                    fontSize: 26.sp,
                                    color: const Color(0xff737A83)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),

                // 确认取消
                // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                //   Container(
                //     margin: const EdgeInsets.only(right: 8),
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: const Text('提交'),
                //     ),
                //   ),
                //   ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(Colors.red)),
                //     onPressed: () {},
                //     child: const Text('取消'),
                //   ),
                // ])
              ],
            ),
          ),
        ));
  }
}
