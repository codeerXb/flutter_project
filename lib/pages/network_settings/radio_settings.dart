import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/common_picker.dart';

/// Radio设置
class RadioSettings extends StatefulWidget {
  const RadioSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadioSettingsState();
}

class _RadioSettingsState extends State<RadioSettings> {
  String showVal = '自动';
  int val = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Radio设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 10.sp,
              ),
              InfoBox(
                  boxCotainer: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('状态', style: TextStyle(fontSize: 30.sp)),
                    Text('SIM卡未准备完成', style: TextStyle(fontSize: 30.sp)),
                  ],
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('连接方式',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 0, 0),
                              fontSize: 32.sp)),
                      GestureDetector(
                        onTap: () {
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['自动', '手动'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal = ['自动', '手动'][val]
                                        })
                                  }
                              });
                        },
                        child: Row(
                          children: [
                            Text(showVal,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 32.sp)),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: const Color.fromRGBO(144, 147, 153, 1),
                              size: 30.w,
                            )
                          ],
                        ),
                      ),
                    ]),
              ])),
              Column(children: [
                SizedBox(
                  height: 40.sp,
                ),
                Row(children: const [
                  TitleWidger(title: '4G状态'),
                ]),
                InfoBox(
                  boxCotainer: Column(
                    children: const [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '频点',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '下行频率',
                        righText: '- - MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '上行频率',
                        righText: '- - MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '频段',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '宽带',
                        righText: '- - MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSRP',
                        righText: '- - dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSSI',
                        righText: '- - dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSRQ',
                        righText: '- - dB',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'SINR',
                        righText: '- - dB',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '发射功率',
                        righText: '- - dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'PCI',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'Cell ID',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MCC',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MNC',
                        righText: '- - ',
                      )),
                    ],
                  ),
                ),
              ])
            ])),
      ),
    );
  }
}

class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.blueAccent, fontSize: 32.sp),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0.w),
        margin: EdgeInsets.only(bottom: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: boxCotainer);
  }
}
