import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Installed extends StatefulWidget {
  const Installed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InstalledState();
}

class _InstalledState extends State<Installed> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool? _isChecked = false; // 用于表示Checkbox的选中状态
  List<bool> _checkedList = []; // 用于表示ListView中每个CheckboxListTile的选中状态

  final TextEditingController _textEditingController = TextEditingController();
  List<bool> selected1 = [false, false, false, false, false, false, false];

  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Amazon Appstore.jpg',
      'text': 'Amazon Appstore',
    },
    {
      'img': 'assets/images/Google Play.png',
      'text': 'Google Play',
    },
    // ...
  ];
  void setAllCheckBoxes(bool value) {
    for (int i = 0; i < selected1.length; i++) {
      selected1[i] = value;
    }
  }

  void updateAllCheckBoxes() {
    bool allSelected = true;
    for (int i = 0; i < selected1.length; i++) {
      if (!selected1[i]) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      _isChecked = allSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkedList = List.generate(
      topData.length,
      (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'App Stores'),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => closeKeyboard(context),
            child: Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              height: 706,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    // child: Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     color: const Color.fromARGB(255, 248, 248, 248),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const Padding(
                    //         padding: EdgeInsets.only(left: 16, right: 8),
                    //         child: Icon(Icons.search),
                    //       ),
                    //       Expanded(
                    //         child: TextField(
                    //           controller: _textEditingController,
                    //           // style: const TextStyle(
                    //           //   color: Colors.black87, // 将文本颜色加深
                    //           // ),
                    //           decoration: const InputDecoration(
                    //             hintText: 'Search',
                    //             border: InputBorder.none,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select which apps can access the Internet.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(136, 135, 135, 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: CheckboxListTile(
                      title: const Text('Select all'),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                          // 当Checkbox的选中状态改变时，将ListView中每个CheckboxListTile的选中状态也改变
                          setAllCheckBoxes(value);
                        });
                      },
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  //   child: Text(
                  //     'Popular apps',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                    child: Column(
                      children: topData.map((data) {
                        final index = topData.indexOf(data);
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    data['img'],
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(data['text']),
                                  const Spacer(),
                                  Checkbox(
                                    value: selected1[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selected1[index] = value!;
                                      });
                                      updateAllCheckBoxes();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (index != topData.length - 1)
                              const Divider(height: 1),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       color: const Color.fromARGB(255, 248, 248, 248),
                  //     ),
                  //     child: ListView.builder(
                  //       itemCount: topData.length,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return Column(
                  //           children: [
                  //             ListTile(
                  //               leading: Image.asset(
                  //                 topData[index]['img'],
                  //                 width: 40, // 设置图片宽度
                  //                 height: 40,
                  //               ),
                  //               title: Text(topData[index]['text']),
                  //               trailing: Checkbox(
                  //                 value: _checkedList[index],
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     _checkedList[index] = value!;
                  //                   });
                  //                 },
                  //               ),
                  //             ),
                  //             const Divider(),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  const Center(
                    child: Text(
                      "Don't see what you're looking for?",
                      style: TextStyle(color: Color.fromRGBO(136, 135, 135, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
