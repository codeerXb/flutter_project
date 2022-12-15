import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import '../../core/widget/custom_app_bar.dart';

/// WLAN设置
class WlanSet extends StatefulWidget {
  const WlanSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanSetState();
}

class _WlanSetState extends State<WlanSet> {
  //频段
  String pdShowVal = '2.4GHz';
  int pdVal = 0;
  //模式
  String msShowVal = '802.11n/g';
  int msVal = 0;
  //带宽
  String kdShowVal = '20 MHz';
  int kdVal = 0;
  //信道
  String xtShowVal = 'Auto';
  int xtVal = 0;
  //发射功率
  String fsShowVal = '100%';
  int fsVal = 0;
  //安全
  String aqShowVal = 'WPA2-PSK';
  int aqVal = 0;
  //WPA加密
  String wpaShowVal = 'AES(推荐)';
  int wpaVal = 0;
  //check
  bool isCheck = true;
  bool apisCheck = true;
  bool ssidisCheck = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WLAN设置'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 2000.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TitleWidger(title: '一般设置'),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //频段
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('频段',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: ['2.4GHz', '5GHz'],
                                value: pdVal,
                              );
                              result?.then((selectedValue) => {
                                    if (pdVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              pdVal = selectedValue,
                                              pdShowVal =
                                                  ['2.4GHz', '5GHz'][pdVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(pdShowVal,
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

                    //WLAN
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('WLAN',
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

                    //模式
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('模式',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  '802.11n/g',
                                  '802.11axg',
                                  '802.11g Only',
                                  '802.11b Only'
                                ],
                                value: msVal,
                              );
                              result?.then((selectedValue) => {
                                    if (msVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              msVal = selectedValue,
                                              msShowVal = [
                                                '802.11n/g',
                                                '802.11axg',
                                                '802.11g Only',
                                                '802.11b Only'
                                              ][msVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(msShowVal,
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
                    //带宽
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('带宽',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  '20 MHz',
                                  '20/40 MHz',
                                ],
                                value: kdVal,
                              );
                              result?.then((selectedValue) => {
                                    if (kdVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              kdVal = selectedValue,
                                              kdShowVal = [
                                                '20 MHz',
                                                '20/40 MHz',
                                              ][kdVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(kdShowVal,
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
                    //信道
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('信道',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  'Auto',
                                  '1',
                                  '2',
                                  '3',
                                  '4',
                                  '5',
                                  '6',
                                  '7',
                                  '8',
                                  '9',
                                  '10',
                                  '11',
                                  '12',
                                  '13'
                                ],
                                value: xtVal,
                              );
                              result?.then((selectedValue) => {
                                    if (xtVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              xtVal = selectedValue,
                                              xtShowVal = [
                                                'Auto',
                                                '1',
                                                '2',
                                                '3',
                                                '4',
                                                '5',
                                                '6',
                                                '7',
                                                '8',
                                                '9',
                                                '10',
                                                '11',
                                                '12',
                                                '13'
                                              ][xtVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(xtShowVal,
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
                    //发射功率
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('发射功率',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  '100%',
                                  '50%',
                                  '20%',
                                ],
                                value: fsVal,
                              );
                              result?.then((selectedValue) => {
                                    if (fsVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              fsVal = selectedValue,
                                              fsShowVal = [
                                                '100%',
                                                '50%',
                                                '20%',
                                              ][fsVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(fsShowVal,
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
                )),
                const TitleWidger(title: '配置'),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //最大设备数

                    //隐藏SSID网络
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('隐藏SSID网络',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Row(
                            children: [
                              Switch(
                                value: ssidisCheck,
                                onChanged: (newVal) {
                                  setState(() {
                                    ssidisCheck = newVal;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    //AP隔离
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('AP隔离',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          Row(
                            children: [
                              Switch(
                                value: apisCheck,
                                onChanged: (newVal) {
                                  setState(() {
                                    apisCheck = newVal;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    //安全
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('安全',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  'WPA2-PSK',
                                  'WPA-PSK&WPA2-PSK',
                                  '空(不推荐)'
                                ],
                                value: aqVal,
                              );
                              result?.then((selectedValue) => {
                                    if (aqVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              aqVal = selectedValue,
                                              aqShowVal = [
                                                'WPA2-PSK',
                                                'WPA-PSK&WPA2-PSK',
                                                '空(不推荐)'
                                              ][aqVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(aqShowVal,
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
                    //WPA加密
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('安全',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: [
                                  'AES(推荐)'
                                      'TKIP',
                                  'TKIP&AES',
                                ],
                                value: wpaVal,
                              );
                              result?.then((selectedValue) => {
                                    if (wpaVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              wpaVal = selectedValue,
                                              wpaShowVal = [
                                                'AES(推荐)'
                                                    'TKIP',
                                                'TKIP&AES',
                                              ][wpaVal]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(wpaShowVal,
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
                    //密码
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
