import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/common_picker.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  String showVal = 'NAT';
  int val = 0;
  @override
  void initState() {
    super.initState();
    getTopoData();
  }

  void getTopoData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"networkWanSettingsMode":"nat"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        debugPrint("\n================== 获取在线设备 ==========================");
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('获取在线设备失败：${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'WAN设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 40.sp,
              ),
              Padding(padding: EdgeInsets.only(top: 30.sp)),
              InfoBox(
                boxCotainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('网络模式',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 0, 0),
                              fontSize: 32.sp)),
                      GestureDetector(
                        onTap: () {
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['NAT', 'BPIDGE'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal = ['NAT', 'BPIDGE'][val]
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
              ),
              SizedBox(
                height: 60.sp,
              ),
            ])),
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
        padding: EdgeInsets.all(20.0.sp),
        margin: EdgeInsets.only(bottom: 5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
