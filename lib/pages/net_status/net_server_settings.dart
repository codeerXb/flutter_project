import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

import '../../core/utils/string_util.dart';
import '../../core/widget/common_picker.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

class NetServerSettings extends StatefulWidget {
  const NetServerSettings({super.key});

  @override
  State<NetServerSettings> createState() => _NetServerSettingsState();
}

class _NetServerSettingsState extends State<NetServerSettings> {
  // 套餐类型
  List<String> comboTypeLabel = [
    S.current.StatisticsByFlow,
    S.current.TimeLengthStatistics
  ];
  int comboType = 0;
  // 套餐容量
  double comboContain = -1;
  final TextEditingController _containController = TextEditingController();
  // 套餐周期
  List<String> comboCycleLabel = [
    S.current.day,
    S.current.month,
    S.current.year
  ];
  int comboCycle = 1;

  @override
  void initState() {
    super.initState();
    sharedGetData('c_type', int).then((data) => {
          if (StringUtil.isNotEmpty(data))
            {
              setState(
                () => comboType = data as int,
              )
            }
        });
    sharedGetData('c_contain', double).then((data) => {
          _containController.text = data != null ? data.toString() : '----',
          if (data != null)
            setState(
              () => comboContain = data as double,
            )
        });
    sharedGetData('c_cycle', int).then((data) => {
          if (StringUtil.isNotEmpty(data))
            {
              setState(
                () => comboCycle = data as int,
              )
            }
        });
    debugPrint('套餐容量：${_containController.text}-$comboContain');
    _containController.addListener(() {
      debugPrint('监听输入的套餐容量：$_containController');
      try {
        if (_containController.text != '----') {
          setState(() {
            comboContain = double.parse(_containController.text);
          });
        }
      } catch (err) {
        debugPrint('输入值错误,$err');
      }
    });
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: S.of(context).PackageSetting,
          titleColor: Colors.white,
          backgroundColor: const Color(0xFF2F5AF5),
          result: {
            'type': comboType,
            'contain': comboContain,
            'cycle': comboCycle
          }),
      backgroundColor: Colors.grey.shade100,
      body: GestureDetector(
        onTap: () => closeKeyboard(context),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                closeKeyboard(context);
                var result = CommonPicker.showPicker(
                  context: context,
                  options: comboTypeLabel,
                  value: comboType,
                );
                if (result != null) {
                  result.then((selectedValue) => {
                        if (selectedValue != null)
                          {
                            setState(
                              () => comboType = selectedValue,
                            )
                          }
                      });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 26.w, right: 26.w, top: 32.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.w))),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).TypeOfPackage,
                          style: TextStyle(
                              height: 1.1,
                              color: const Color.fromARGB(255, 5, 0, 0),
                              fontSize: 32.sp)),
                      Row(
                        children: [
                          Text(comboTypeLabel[comboType],
                              style: TextStyle(
                                  height: 1.1,
                                  color:
                                      const Color.fromARGB(255, 108, 108, 109),
                                  fontSize: 32.sp)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: const Color.fromARGB(255, 5, 0, 0),
                            size: 30.w,
                          )
                        ],
                      ),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 26.w, right: 26.w, top: 16.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16.w))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        comboType == 0
                            ? S.of(context).PackageCapacity
                            : S.of(context).PackageDuration,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 5, 0, 0),
                            fontSize: 32.sp)),
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: TextField(
                            controller: _containController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 108, 108, 109)),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 42.0.w, bottom: 6.0.w)),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                                  LengthLimitingTextInputFormatter(10)
                            ],
                            keyboardType: TextInputType.number,
                            // maxLength: 10,
                            onTap: () => _containController.selection =
                                TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _containController.text.length),
                          ),
                        ),
                        Text(comboType == 0 ? 'GB' : 'h',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 5, 0, 0),
                                fontSize: 32.sp))
                      ],
                    ),
                  ]),
            ),
            GestureDetector(
              onTap: () {
                closeKeyboard(context);
                var result = CommonPicker.showPicker(
                  context: context,
                  options: comboCycleLabel,
                  value: comboCycle,
                );
                if (result != null) {
                  result.then((selectedValue) => {
                        if (selectedValue != null)
                          {
                            setState(
                              () => comboCycle = selectedValue,
                            )
                          }
                      });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 26.w, right: 26.w, top: 16.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.w))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).cycle,
                        style: TextStyle(
                            height: 1.1,
                            color: const Color.fromARGB(255, 5, 0, 0),
                            fontSize: 32.sp)),
                    Row(
                      children: [
                        Text(comboCycleLabel[comboCycle],
                            style: TextStyle(
                                height: 1.1,
                                color: const Color.fromARGB(255, 108, 108, 109),
                                fontSize: 32.sp)),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: const Color.fromARGB(255, 5, 0, 0),
                          size: 30.w,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('套餐设置页面销毁');
    _containController.dispose();
    sharedAddAndUpdate('c_type', int, comboType);
    if (comboContain >= 0) {
      sharedAddAndUpdate('c_contain', double, comboContain);
    }
    sharedAddAndUpdate('c_cycle', int, comboCycle);
  }
}
