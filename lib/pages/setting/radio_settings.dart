import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/common_box.dart';

/// Radio设置
class RadioSettings extends StatefulWidget {
  const RadioSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadioSettingsState();
}

class _RadioSettingsState extends State<RadioSettings> {
  int sex = 1;
  int status = 1;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Radio设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            height: 1440.sp,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 10.sp,
              ),
              InfoBox(
                boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('状态', style: TextStyle(fontSize: 30.sp)),
                    Text('SIM卡未准备完成', style: TextStyle(fontSize: 30.sp))
                  ],
                ),
              ),
              InfoBox(
                boxCotainer: Row(children: [
                  Flexible(
                    child: Text('连接方式', style: TextStyle(fontSize: 30.sp)),
                  ),
                  SizedBox(
                    width: 220.sp,
                  ),
                  Radio(
                    // 按钮的值
                    value: 1,
                    // 改变事件
                    onChanged: (value) {
                      setState(() {
                        sex = value.hashCode;
                      });
                    },
                    // 按钮组的值
                    groupValue: sex,
                  ),
                  const Text("手动"),
                  SizedBox(
                    width: 20.sp,
                  ),
                  Radio(
                    value: 2,
                    onChanged: (value) {
                      setState(() {
                        sex = value.hashCode;
                      });
                    },
                    groupValue: sex,
                  ),
                  const Text("自动"),
                ]),
              ),
              SizedBox(
                height: 30.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 70.sp,
                    width: 700.sp,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('提交'),
                    ),
                  )
                ],
              ),
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
                        leftText: '下行频率',
                        righText: '- - MHZ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '上行频率',
                        righText: '- - MHZ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'Band',
                        righText: '- - ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'Bandwidth',
                        righText: '- - MHZ',
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
                        righText: '- - MHZ',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MNC',
                        righText: '- - MHZ',
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
        style: TextStyle(color: Colors.blue, fontSize: 32.sp),
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
        padding: EdgeInsets.all(10.0.w),
        margin: EdgeInsets.only(bottom: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: boxCotainer);
  }
}
