import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

class ParentDetailListPage extends StatefulWidget {
  const ParentDetailListPage({super.key});

  @override
  State<ParentDetailListPage> createState() => _ParentDetailListPageState();
}

class _ParentDetailListPageState extends State<ParentDetailListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("E-Commerce Portal Access Times",
              style: TextStyle(fontSize: 24, color: Colors.black)),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          // height: double.infinity,
          padding: EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return createLineChart();
              }),
        ));
  }

  Widget createLineChart() {
    return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 40,
            minHeight: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "app",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: SizedBox(
                height: 25,
                child: DChartSingleBar(
                  radius: BorderRadius.circular(5),
                  foregroundLabelAlign: Alignment.centerLeft,
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.green,
                  value: 0.7,
                  max: 1.0,
                ),
              )),
              SizedBox(
                width: 5,
              ),
              Text(
                "300s",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
          ),
        );
  }
}
