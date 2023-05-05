import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../net_status/index.dart';

/// 家长控制
class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  //选中time period
  bool isFirst = true;
  //选择日期
  String date = 'Sun';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Parental control'),
        body: Container(
          padding: EdgeInsets.all(26.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopCard(),

                Padding(padding: EdgeInsets.only(top: 20.w)),
                //Internet usage today
                Container(
                    padding: EdgeInsets.all(28.0.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.w),
                    ),
                    child: Column(
                      children: [
                        //第一行
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //left
                            const Text('Internet usage today'),
                            //right
                            Row(
                              children: [
                                Text('More',
                                    style: TextStyle(
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        fontSize: 30.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 60.w)),
                        const Image(
                          image: AssetImage('assets/images/butterfly.png'),
                        ),
                        Padding(padding: EdgeInsets.only(top: 60.w)),

                        //第三行
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                Get.toNamed('/Internet');
                              }),
                              child: Column(
                                children: [
                                  const Text(
                                    'Online',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  Text(
                                    '0 min',
                                    style: TextStyle(
                                        fontSize: 36.w, color: Colors.black87),
                                  ),
                                  const Text(
                                    'Healthy Internet access',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                Get.toNamed('/Internet');
                              }),
                              child: Column(
                                children: [
                                  const Text(
                                    'Left',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  Text(
                                    'Not Set',
                                    style: TextStyle(
                                        fontSize: 36.w, color: Colors.black87),
                                  ),
                                  const Text(
                                    'Add 10 min',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 60.w)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 300.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.wifi_off_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 40.w,
                                  ),
                                  const Text(
                                    'Disconnect',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 40.w,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 300.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 40.w,
                                  ),
                                  const Text(
                                    'No Limits',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 20.w)),
                SizedBoxs(),
                Container(
                    padding: EdgeInsets.all(28.0.w),
                    // margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.w),
                    ),
                    child: Column(
                      children: [
                        //第一行
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //left
                            const Text('Internet access time management'),
                            //right
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/Internetaccess');
                              },
                              child: Row(
                                children: [
                                  Text('Settings',
                                      style: TextStyle(
                                          color: const Color.fromRGBO(
                                              144, 147, 153, 1),
                                          fontSize: 30.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isFirst = true;
                                });
                              },
                              child: Text(
                                'time period',
                                style: TextStyle(
                                    color:
                                        isFirst ? Colors.blue : Colors.black54),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isFirst = false;
                                });
                              },
                              child: Text(
                                'duration',
                                style: TextStyle(
                                    color: !isFirst
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            )
                          ],
                        ),
                        Image(
                          image: isFirst
                              ? AssetImage('assets/images/leftTime.png')
                              : AssetImage('assets/images/Durationtime.png'),
                        ),

                        Row(
                          // scrollDirection: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Sun
                            // TextButton(

                            //   onPressed: () {
                            //     setState(() {
                            //       date = 'Sun';
                            //     });
                            //   },
                            //   child: Text(
                            //     'Sun',
                            //     style: TextStyle(
                            //         color: date == 'Sun'
                            //             ? Colors.blue
                            //             : Colors.black54),
                            //   ),
                            // ),
                            //Mon
                            TextButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(10, 10))),

                              // style: ButtonStyle(fixedSize:MaterialStateProperty.all(const Size.fromHeight(5)) ),
                              onPressed: () {
                                setState(() {
                                  date = 'Mon';
                                });
                              },
                              child: Text(
                                'Mon',
                                style: TextStyle(
                                    color: date == 'Mon'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            ),
                            //Tue
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  date = 'Tue';
                                });
                              },
                              child: Text(
                                'Tue',
                                style: TextStyle(
                                    color: date == 'Tue'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            ),
                            //Wed
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  date = 'Wed';
                                });
                              },
                              child: Text(
                                'Wed',
                                style: TextStyle(
                                    color: date == 'Wed'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            ),
                            //Thu
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  date = 'Thu';
                                });
                              },
                              child: Text(
                                'Thu',
                                style: TextStyle(
                                    color: date == 'Thu'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            ),
                            // Fri
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  date = 'Fri';
                                });
                              },
                              child: Text(
                                'Fri',
                                style: TextStyle(
                                    color: date == 'Fri'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            ),
                            // //Sat
                            // TextButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       date = 'Sat';
                            //     });
                            //   },
                            //   child: Text(
                            //     'Sat',
                            //     style: TextStyle(
                            //         color: date == 'Sat'
                            //             ? Colors.blue
                            //             : Colors.black54),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}

//头部标题
class TopCard extends StatelessWidget {
  const TopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.hardEdge,
      elevation: 5, //设置卡片阴影的深度
      shape: RoundedRectangleBorder(
        //设置卡片圆角
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Image(
        image: AssetImage('assets/images/title.jpg'),
        fit: BoxFit.fill,
      ),
      // Column(
      //   children: [
      //     ListTile(
      //       // contentPadding: EdgeInsets.only(
      //       //     top: 20.w, bottom: 20.w, left: 40.w, right: 40.w),
      //       //图片
      //       leading: ClipOval(
      //           child: Image.asset('assets/images/phone.png',
      //               fit: BoxFit.fitWidth, height: 50, width: 50)),
      //       //中间文字
      //       title: Text('Unknown equipment-0FC1'),
      //       //title下方显示的内容
      //       subtitle: Text('Offline'),
      //       //标题后显示的widget
      //     ),
      //   ],
      // ),
    );
  }
}

//卡片
class SizedBoxs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520.w,
      child: GridView(
        physics: const NeverScrollableScrollPhysics(), //禁止滚动
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //一行的Widget数量
          childAspectRatio: 2, //宽高比为1
          crossAxisSpacing: 22, //横轴方向子元素的间距
        ),
        children: <Widget>[
          //Games
          GestureDetector(
            onTap: () {
              Get.toNamed('/games');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.games,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Games'),
                        Text(
                          '135 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
          //Video
          GestureDetector(
            onTap: () {
              Get.toNamed('/Video');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.videocam_rounded,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Video'),
                        Text(
                          '26 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
          //Social
          GestureDetector(
            onTap: () {
              Get.toNamed('/Social');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.chat_rounded,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child:
                                const FittedBox(child: Text('Social media'))),
                        Text(
                          '2 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
          //payment
          GestureDetector(
            onTap: () {
              Get.toNamed('/Payment');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.payment,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment'),
                        Text(
                          '4 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
          //Installed
          GestureDetector(
            onTap: () {
              Get.toNamed('/Installed');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.install_mobile,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Installed'),
                        Text(
                          '8 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
          //URL blocklist
          GestureDetector(
            onTap: () {
              Get.toNamed('/Blocklist');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(Icons.block,
                            color: Colors.blue[500], size: 80.sp)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child: const FittedBox(
                                child: Text('Website Blocklist'))),
                        Text(
                          '2 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: const Color.fromRGBO(144, 147, 153, 1),
                  size: 30.w,
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
