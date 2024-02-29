import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentDevicePage extends StatefulWidget {
  const ParentDevicePage({super.key});

  @override
  State<ParentDevicePage> createState() => _ParentDevicePageState();
}

class _ParentDevicePageState extends State<ParentDevicePage> {
  RxList deviceList = [].obs;
  bool? cancheck = false;
  @override
  void initState() {
    for (int i = 1; i < 5; i++) {
      deviceList.add("device$i");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Blacklist Configure',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 100,
                  // maxHeight: 100000
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 30),
                      child: Obx(() {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffe5e5e5)))),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: deviceList.length,
                            itemBuilder: (context, index) {
                              return setUpContentView();
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 20,
                                thickness: 10,
                                color: Color.fromARGB(255, 214, 208, 208),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              )),
              // Positioned(
              //   left: 80,
              //   right: 80,
              //   bottom: 20,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       padding: MaterialStateProperty.all(
              //         EdgeInsets.only(top: 28.w, bottom: 28.w),
              //       ),
              //       shape: MaterialStateProperty.all(const StadiumBorder()),
              //       backgroundColor: MaterialStateProperty.all(
              //           const Color.fromARGB(255, 30, 104, 233)),
              //     ),
              //     onPressed: () {
              //       Get.toNamed("/websiteTimeListPage");
              //     },
              //     child: Text(
              //       "Next Step",
              //       style: TextStyle(
              //           fontSize: 32.sp, color: const Color(0xffffffff)),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }

  Widget setUpContentView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Device",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      Get.toNamed("/parentConfigPage");
                    },
                    icon: Image.asset(
                      "assets/images/edit_parent.png",
                      width: 20,
                      height: 20,
                    ))
              ],
            ),
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/images/shopping.png",
            width: 20,
            height: 20,
          ),
          title: Text(
            "Next Step,Next Step,Next Step,Next Step",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/images/shopping.png",
            width: 20,
            height: 20,
          ),
          title: Text(
            "Next Step,Next Step,Next Step,Next Step",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/images/shopping.png",
            width: 20,
            height: 20,
          ),
          title: Text(
            "Next Step,Next Step,Next Step,Next Step",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/images/shopping.png",
            width: 20,
            height: 20,
          ),
          title: Text(
            "Next Step,Next Step,Next Step,Next Step",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
