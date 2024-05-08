import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:get/get.dart';

class ParentDetailListPage extends StatefulWidget {
  const ParentDetailListPage({super.key});

  @override
  State<ParentDetailListPage> createState() => _ParentDetailListPageState();
}

class _ParentDetailListPageState extends State<ParentDetailListPage> {

  List appTimeList = [];

  @override
  void initState() {
    setState(() {
      appTimeList = Get.arguments["timeArray"];
    });
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("E-Commerce Portal Access Times",
              style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500)),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: appTimeList.length,
              itemBuilder: (BuildContext context, int index) {
                return createLineChart(appTimeList[index].appName,appTimeList[index].visitTime);
              }),
        ));
  }

  Widget createLineChart(String appName, String timeValue) {
    double timeP = int.parse(timeValue) / int.parse(appTimeList[0].visitTime);
    double timev = double.parse(timeP.toStringAsFixed(1));
    return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 40,
            minHeight: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appName,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 15,
              ),
            Expanded(
              child: SizedBox(
                height: 25,
                child: DChartSingleBar(
                  radius: BorderRadius.circular(5),
                  foregroundLabelAlign: Alignment.centerLeft,
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromRGBO(2, 123, 254, 1),
                  backgroundLabelAlign: Alignment.bottomRight,
                  backgroundLabelPadding: const EdgeInsets.only(right: 20),
                  backgroundLabel: Text(
                "${timeValue}s",
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
                  value: timev,
                  max: 1.0,
                ),
              )),
            const SizedBox(
                width: 5,
              ),
              Text(
                "$timeValue mins",
                style: const TextStyle(fontSize: 14, color: Colors.blue,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
  }
}
