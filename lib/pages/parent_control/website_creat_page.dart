import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentWebSitePage extends StatefulWidget {
  const ParentWebSitePage({super.key});

  @override
  State<ParentWebSitePage> createState() => _ParentWebSitePageState();
}

class _ParentWebSitePageState extends State<ParentWebSitePage> {
  RxList websites = [].obs;
  FocusNode fousNode = FocusNode();
  bool switchValue = true;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Website List',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          // actions: [
          //   FlutterSwitch(
          //     width: 100.0,
          //     height: 40.0,
          //     activeText: "Blacklist",
          //     inactiveText: "Whitelist",
          //     activeColor: const Color.fromARGB(255, 22, 136, 230),
          //     activeTextColor: Colors.white,
          //     inactiveTextColor: Colors.blue[50]!,
          //     value: switchValue,
          //     valueFontSize: 12.0,
          //     borderRadius: 30.0,
          //     showOnOff: true,
          //     onToggle: (val) {
          //       setState(() {
          //         switchValue = val;
          //       });
          //     },
          //   ),
          //   const SizedBox(
          //     width: 15,
          //   )
          // ],
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          padding: const EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              // maxHeight: 100000
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Image.asset(
                              "assets/images/weblist.png",
                              width: 25,
                              height: 25,
                            )),
                        Expanded(
                            child: TextField(
                          controller: textController,
                          autofocus: true,
                          focusNode: fousNode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Your Name',
                              suffix: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: TextButton(
                                    onPressed: () {
                                      websites.add(textController.text);
                                    },
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.blue),
                                    )),
                              )),
                        ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 30),
                  child: Obx(() {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffe5e5e5)))),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: websites.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xffe5e5e5)))),
                              child: ListTile(
                                title: Text(
                                  websites[index],
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "assets/images/delete2.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(top: 28.w, bottom: 28.w),
                      ),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 30, 104, 233)),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Finish",
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xffffffff)),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
