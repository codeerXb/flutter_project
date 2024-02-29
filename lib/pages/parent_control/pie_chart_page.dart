import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  var key = GlobalKey<_PieChartPageState>();
  bool _isOpenControlInRow = true;
  List<String> devices = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8'
  ];
  String? selectedValue;
  String dropDownValue = "one";
  final List<PieData> pies = [
    PieData(value: 15, color: const Color(0xfffdcb6e)),
    PieData(value: 35, color: const Color(0xff0984e3)),
    PieData(value: 45, color: Colors.lightGreen),
    PieData(value: 25, color: const Color(0xfffd79a8)),
    PieData(value: 5, color: const Color(0xff6c5ce7))
  ];
  final List<NumericData> piedata = [
    NumericData(domain: 15, measure: 100),
    NumericData(domain: 25, measure: 200),
    NumericData(domain: 45, measure: 400),
    NumericData(domain: 25, measure: 200),
    NumericData(domain: 5, measure: 50),
  ];

  List<OrdinalData> ordinalDataList = [
    OrdinalData(domain: 'Shopping', measure: 130, color:const Color.fromRGBO(2, 123, 254, 1)),
    OrdinalData(domain: 'Video', measure: 250, color:const Color.fromRGBO(88, 86, 215, 1)),
    OrdinalData(domain: 'App Store', measure: 200, color:const Color.fromRGBO(255, 149, 0, 1)),
    OrdinalData(domain: 'Social', measure: 260, color:const Color.fromRGBO(53, 199, 89, 1)),
    OrdinalData(domain: 'Website', measure: 140, color:const Color.fromRGBO(255, 165, 40, 1))
  ];

  List resList = [
    {
      "imgurl": "assets/images/shopping.png",
      "title": "E-Commerce Portal Access Times",
      "time": "123mins"
    },
    {"imgurl": "assets/images/video.png", "title": "Video", "time": "123mins"},
    {
      "imgurl": "assets/images/app store.png",
      "title": "App Store",
      "time": "123mins"
    },
    {
      "imgurl": "assets/images/social media.png",
      "title": "Social Media",
      "time": "123mins"
    },
    {
      "imgurl": "assets/images/weblist.png",
      "title": "Website List",
      "time": "123mins"
    },
  ];

  String tapIndex = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parental Control Dashboard",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          FlutterSwitch(
            width: 80.0,
            height: 40.0,
            activeText: "ON",
            inactiveText: "OFF",
            activeColor: Colors.green,
            activeTextColor: Colors.white,
            inactiveTextColor: Colors.blue[50]!,
            value: _isOpenControlInRow,
            valueFontSize: 12.0,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                _isOpenControlInRow = val;
              });
            },
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: setUpBodyContent(),
    );
  }

  Widget getPieChart() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartPieO(
        key: key,
        data: ordinalDataList,
        configRenderPie: ConfigRenderPie(
            arcWidth: 40,
            // arcRatio: 0.1,
            strokeWidthPx: 0.0,
            arcLabelDecorator: ArcLabelDecorator(
                labelPosition: ArcLabelPosition.outside,
                outsideLabelStyle: const LabelStyle(fontSize: 12),
                leaderLineStyle: const ArcLabelLeaderLineStyle(
                    color: Colors.black, length: 20, thickness: 1.0))),
      ),
    );
  }

  Widget setUpBodyContent() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 20,
            minHeight: 100),
        child: _isOpenControlInRow
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: setDropdownMenue(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(height: 240, child: getPieChart()),
                  // EasyPieChart(
                  //   key: key,
                  //   children: pies,
                  //   pieType: PieType.fill,
                  //   onTap: (index) {
                  //     Get.toNamed("/parentDetailList");
                  //     debugPrint("当前选中的是$index");
                  //   },
                  //   start: 180,
                  //   size: 400,
                  //   style: const TextStyle(
                  //       fontSize: 20,
                  //       color: Colors.black,
                  //       backgroundColor: Colors.white),
                  //   // child: Text("当前占比30%"),
                  //   // centerStyle: TextStyle(fontSize: 16,color: Colors.black),
                  // ),

                  const SizedBox(
                    height: 30,
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return getAppcationTypeList(resList[index]["imgurl"],
                          resList[index]["title"], resList[index]["time"]);
                    },
                  ),

                  setUpFooterView()
                  // SizedBox(
                  //   height: 80,
                  //   child: buildCustomWidget(),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // )
                ],
              )
            : Container(),
      ),
    );
  }

  Widget setUpFooterView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w)
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233)),
                  ),
                  onPressed: () {
                    // Get.toNamed("/parentConfigPage");
                    Get.toNamed("/websiteDevicePage");
                  },
                  child: Text(
                    "Blacklist Configure",
                    style: TextStyle(
                        fontSize: 32.sp, color: const Color(0xffffffff)),
                  ),
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w),
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(52, 199, 89, 1)),
                  ),
                  onPressed: () {
                    Get.toNamed("/timeConfigPage");
                  },
                  child: Text(
                    "Use Time Configure",
                    style: TextStyle(
                        fontSize: 32.sp, color: const Color(0xffffffff)),
                  ),
                ),
      ],
    );
  }

  Widget getAppcationTypeList(String imgPath, String title, String totalTime) {
    return InkWell(
      onTap: () {
        Get.toNamed("/parentDetailList");
      },
      child: Container(
        decoration:const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        height: 60,
        child: ListTile(
          leading: Image.asset(
            imgPath,
            width: 20,
            height: 20,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          trailing: Text(
            totalTime,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget setDropdownMenue() {
    return
        // DropdownButton<String>(
        //   value: dropDownValue,
        //   icon: Icon(Icons.keyboard_arrow_down),
        //   items: devices.map((String items) {
        //     return DropdownMenuItem(value: items, child: Text(items));
        //   }).toList(),
        //   onChanged: (String? newValue) {
        //     setState(() {
        //       dropDownValue = newValue!;
        //     });
        //   },
        // );
        Center(
        child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              // Icon(
              //   Icons.list,
              //   size: 16,
              //   color: Colors.yellow,
              // ),
              // SizedBox(
              //   width: 4,
              // ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: devices
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 260,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.white,
              ),
              color: Color.fromRGBO(247, 248, 250, 1),
            ),
            elevation: 0,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 260,
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget setUpTopView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: SwitchListTile(
            value: _isOpenControlInRow,
            title: const Text("control switch"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                _isOpenControlInRow = val;
              });
            },
          ),
        ),
        Expanded(
            child: SizedBox(
          width: 40,
          height: 30,
          child: IconButton(
              onPressed: () {
                Get.toNamed("/parentConfigHome");
              },
              icon: const Icon(Icons.settings)),
        )),
        // Divider(
        //   height: 1.0,
        //   indent: 60.0,
        //   color: Colors.black,
        // )
      ],
    );
  }

  Widget buildCustomWidget() {
    return Center(
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            createWrapChild("social media", const Color(0xfffdcb6e)),
            createWrapChild("shopping", const Color(0xff0984e3)),
            createWrapChild("app", Colors.lightGreen),
            createWrapChild("video", const Color(0xfffd79a8)),
            createWrapChild("website", const Color(0xff6c5ce7)),
          ],
        ),
      ),
    );
  }

  Widget createWrapChild(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          height: 20.0,
          width: 18.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            softWrap: true,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(padding: const EdgeInsets.all(20.0), child: child));
  }
}
