import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import '../../core/widget/custom_app_bar.dart';

/// 专业设置

class MajorSet extends StatefulWidget {
  const MajorSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MajorSetState();
}

class _MajorSetState extends State<MajorSet> {
  String showVal = '中国';
  int val = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '专业设置'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '专业设置'),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //地区
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('地区',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  '中国',
                                  '法国',
                                  '俄罗斯',
                                  '美国',
                                  '新加坡',
                                  '澳大利亚',
                                  '智利',
                                  '波兰'
                                ],
                                value: val,
                              );
                              result?.then((selectedValue) => {
                                    if (val != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              val = selectedValue,
                                              showVal = [
                                                '中国',
                                                '法国',
                                                '俄罗斯',
                                                '美国',
                                                '新加坡',
                                                '澳大利亚',
                                                '智利',
                                                '波兰'
                                              ][val]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(showVal,
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
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
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
