import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool? _isChecked = false; // 用于表示Checkbox的选中状态
  List<bool> _checkedList = []; // 用于表示ListView中每个CheckboxListTile的选中状态

  final TextEditingController _textEditingController = TextEditingController();

  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/Google Pay.jpg',
      'text': 'Google Pay',
    },
    {
      'img': 'assets/images/PayPal .jpg',
      'text': 'PayPal',
    },
    {
      'img': 'assets/images/Apple pay.jpg',
      'text': 'Apple pay',
    },
    {
      'img': 'assets/images/Venmo.jpg',
      'text': 'Venmo',
    },
    // ...
  ];

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
        appBar: customAppbar(context: context, title: 'Payment Service'),
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
                  // Padding(
                  //   padding: const EdgeInsets.all(16),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: const Color.fromARGB(255, 248, 248, 248),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const Padding(
                  //           padding: EdgeInsets.only(left: 16, right: 8),
                  //           child: Icon(Icons.search),
                  //         ),
                  //         Expanded(
                  //           child: TextField(
                  //             controller: _textEditingController,
                  //             // style: const TextStyle(
                  //             //   color: Colors.black87, // 将文本颜色加深
                  //             // ),
                  //             decoration: const InputDecoration(
                  //               hintText: 'Search',
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select which apps can access the Internet.',
                      style: TextStyle(fontSize: 16),
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
                          for (int i = 0; i < _checkedList.length; i++) {
                            _checkedList[i] = value;
                          }
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
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                      child: ListView.builder(
                        itemCount: topData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Image.asset(
                                  topData[index]['img'],
                                  width: 40, // 设置图片宽度
                                  height: 40,
                                ),
                                title: Text(topData[index]['text']),
                                trailing: Checkbox(
                                  value: _checkedList[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _checkedList[index] = value!;
                                    });
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  const Center(
                    child: Text('Dont see what youer looking for?'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
