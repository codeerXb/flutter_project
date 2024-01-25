import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';

class ParentCreatTimePage extends StatefulWidget {
  const ParentCreatTimePage({super.key});

  @override
  State<ParentCreatTimePage> createState() => _ParentCreatTimePageState();
}

class _ParentCreatTimePageState extends State<ParentCreatTimePage> {
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  List weeks = [
    "Every Monday",
    "Every Tuesday",
    "Every Wednesday",
    "Every Thursday",
    "Every Friday",
    "Every Saturday",
    "Every Sunday"
  ];

  List<bool> checked = List<bool>.filled(7, false);
  List checkWeeks = [];

  // bool? monCheck = false;
  // bool? tusCheck = false;
  // bool? wedCheck = false;
  // bool? turCheck = false;
  // bool? friCheck = false;
  // bool? satuCheck = false;
  // bool? sunCheck = false;

  void _showStartTimePicker() async {
    final pickedTime = await showSpinnerTimePicker(
      context,
      initTime: selectedStartTime,
      is24HourFormat: true,
    );

    if (pickedTime != null) {
      setState(() {
        selectedStartTime = pickedTime;
        debugPrint("当前选择的时间是:${pickedTime.hour}:${pickedTime.minute}");
      });
    }
  }

  void _showEndTimePicker() async {
    final pickedTime = await showSpinnerTimePicker(
      context,
      initTime: selectedEndTime,
      is24HourFormat: true,
    );

    if (pickedTime != null) {
      setState(() {
        selectedEndTime = pickedTime;
        debugPrint("当前选择的时间是:${pickedTime.hour}:${pickedTime.minute}");
      });
    }
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
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                createTimeRange(),
                const SizedBox(
                  height: 20,
                ),
                setUpWeeklyView(),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     setUpWeeklyView(monCheck, weeks[0]),
                //     setUpWeeklyView(tusCheck, weeks[1]),
                //     setUpWeeklyView(wedCheck, weeks[2]),
                //     setUpWeeklyView(turCheck, weeks[3]),
                //     setUpWeeklyView(friCheck, weeks[4]),
                //     setUpWeeklyView(satuCheck, weeks[5]),
                //     setUpWeeklyView(sunCheck, weeks[6]),
                //   ],
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            )),
            Positioned(
                left: 80,
                right: 80,
                bottom: 20,
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
                ))
          ],
        ),
      ),
    );
  }

  Widget createTimeRange() {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration:const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Starting time',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(
                  width: 5,
                ),

                Text('End Time',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                //     SizedBox(
                //   width: 5,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${selectedStartTime.hour}:${selectedStartTime.minute.toString().padLeft(2, '0')}',
                style:const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                '--',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  '${selectedEndTime.hour}:${selectedEndTime.minute.toString().padLeft(2, '0')}',
                  style:const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233))),
                onPressed: _showStartTimePicker,
                child: const Text('Pick a Time'),
              ),
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233))),
                onPressed: _showEndTimePicker,
                child: const Text('Pick a Time'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget setUpWeeklyView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: weeks.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
            child: CheckboxListTile(
              value: checked[index],
              title: Text(
                weeks[index],
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (isChecked) {
                setState(() {
                  checked[index] = isChecked!;
                  if (isChecked) {
                    checkWeeks.add(weeks[index]);
                    debugPrint("当前选中的星期是:$checkWeeks");
                  }else {
                    checkWeeks.remove(weeks[index]);
                    debugPrint("当前选中的星期是:$checkWeeks");
                  }
                  
                });
              },
            ),
          );
        });
  }
}
