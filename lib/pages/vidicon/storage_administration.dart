// 存储管理
import 'package:flutter/material.dart';

class AtorageAdministration extends StatefulWidget {
  const AtorageAdministration({Key? key}) : super(key: key);

  @override
  State<AtorageAdministration> createState() => _AtorageAdministrationState();
}

class _AtorageAdministrationState extends State<AtorageAdministration> {
  @override
  void initState() {
    super.initState();
    // getDnsData();
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: "Cloud"),
                  Tab(text: "Local"),
                  Tab(text: "SD Card"),
                ],
              ),
            ),
            body: TabBarView(children: <Widget>[
              ListView(
                children: const <Widget>[
                  ListTile(title: Text("Not open yet")),
                ],
              ),
              ListView(
                children: const <Widget>[
                  ListTile(title: Text("Not downloaded yet")),
                ],
              ),
              ListView(
                children: [
                  InkWell(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Video Recording Saved',
                                style: TextStyle(fontSize: 18),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 233, 233, 233),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[700],
                                  size: 18,
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2025),
                                  );
                                },
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 233, 233, 233),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey[700],
                                  size: 18,
                                ),
                                onPressed: () {
                                  // showDatePicker(
                                  //   context: context,
                                  //   initialDate: DateTime.now(),
                                  //   firstDate: DateTime(2020),
                                  //   lastDate: DateTime(2025),
                                  // );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/images/storageadministration.jpg',
                          width: 400,
                          height: 580,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ])));
  }
}
