import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentTimeListPage extends StatefulWidget {
  const ParentTimeListPage({super.key});

  @override
  State<ParentTimeListPage> createState() => _ParentTimeListPageState();
}

class _ParentTimeListPageState extends State<ParentTimeListPage> {
  List<Map> timeList = [];

  @override
  void initState() {
    for (int i = 1; i < 5; i++) {
      Map timeMap = {"timeRange": "08:00 - 11:30", "dateRange": "Mon and Wed"};
      timeList.add(timeMap);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Time",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                Get.toNamed("/websiteCreatTimePage");
              },
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: setupTimeListView(timeList),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Supports up to 5 time configuration plans.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
            // Positioned(
            //     left: 80,
            //     right: 80,
            //     bottom: 20,
            //     child: ElevatedButton(
            //       style: ButtonStyle(
            //         padding: MaterialStateProperty.all(
            //           EdgeInsets.only(top: 28.w, bottom: 28.w),
            //         ),
            //         shape: MaterialStateProperty.all(const StadiumBorder()),
            //         backgroundColor: MaterialStateProperty.all(
            //             const Color.fromARGB(255, 30, 104, 233)),
            //       ),
            //       onPressed: () {},
            //       child: Text(
            //         "Submit",
            //         style: TextStyle(
            //             fontSize: 32.sp, color: const Color(0xffffffff)),
            //       ),
            //     ))
          ],
        ),
      ),
    );
  }

  List<Widget> setupTimeListView(List<Map> timeArray) {
    List<Widget> widgets = [];
    for (var timeMap in timeArray) {
      widgets.add(Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: ListTile(
            leading: Image.asset(
              "assets/images/time_parent.png",
              width: 20,
              height: 20,
            ),
            title: Text(
              timeMap["timeRange"],
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timeMap["dateRange"],
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            trailing: Transform(
              transform: Matrix4.translationValues(16, 0, 0),
              child: IconButton(
                onPressed: () {
                  //delete
                },
                icon: Image.asset(
                  "assets/images/delete2.png",
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return widgets;
  }
}
