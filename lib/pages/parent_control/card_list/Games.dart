import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool _isChecked = true; // 用于表示Checkbox的选中状态
  // List<bool> _checkedList = []; // 用于表示ListView中每个CheckboxListTile的选中状态

  final TextEditingController _textEditingController = TextEditingController();
  List<bool> selected1 = [true, true, true, true, true, true, true];
  List<bool> selected2 = [true, true, true, true, true, true];
  List<Map<String, dynamic>> topData = [
    {
      'img': 'assets/images/MONOPOLY GO.jpg',
      'text': 'MONOPOLY GO',
    },
    {
      'img': 'assets/images/Royal Match.jpg',
      'text': 'Royal Match',
    },
    {
      'img': 'assets/images/Candy Crush Saga.jpg',
      'text': 'Candy Crush Saga',
    },
    {
      'img': 'assets/images/Coin Master.jpg',
      'text': 'Coin Master',
    },
    {
      'img': 'assets/images/Watch TNT.jpg',
      'text': 'Watch TNT',
    },
    {
      'img': 'assets/images/Roblox.jpg',
      'text': 'Roblox',
    },
    {
      'img': 'assets/images/Magic Tiles.jpg',
      'text': 'Magic Tiles',
    },
    // ...
  ];

  List<Map<String, dynamic>> otherData = [
    {
      'img': 'assets/images/Call of Duty.jpg',
      'text': 'Call of Duty',
    },
    {
      'img': 'assets/images/Gardenscapes.jpg',
      'text': 'Gardenscapes',
    },
    {
      'img': 'assets/images/Magic Tiles.jpg',
      'text': 'Magic Tiles',
    },
    {
      'img': 'assets/images/Roblox.jpg',
      'text': 'Roblox',
    },
    // ...
  ];

  @override
  void initState() {
    super.initState();
    // _checkedList = List.generate(
    //   topData.length,
    //   (index) => false,
    // );
  }

  void setAllCheckBoxes(bool value) {
    for (int i = 0; i < selected1.length; i++) {
      selected1[i] = value;
    }
    for (int i = 0; i < selected2.length; i++) {
      selected2[i] = value;
    }
  }

  void updateAllCheckBoxes() {
    bool allSelected = true;
    for (int i = 0; i < selected1.length; i++) {
      print('selected1[i]$i');

      if (!selected1[i]) {
        print('selected1[i]${selected1[i]}');
        allSelected = false;
        break;
      }
    }
    if (allSelected) {
      for (int i = 0; i < selected2.length; i++) {
        if (!selected2[i]) {
          allSelected = false;
          break;
        }
      }
    }
    setState(() {
      _isChecked = allSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Games'),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: InkWell(
              onTap: () => closeKeyboard(context),
              child: Container(
                padding: EdgeInsets.only(left: 30.w, right: 30.0.w),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 248, 248, 248),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16, right: 8),
                              child: Icon(Icons.search),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                // style: const TextStyle(
                                //   color: Colors.black87, // 将文本颜色加深
                                // ),
                                decoration: const InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            // 设置两个list view中每个checkbox的选中状态
                            setAllCheckBoxes(value);
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        'Top games',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
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
                    // 暂时留下 作为备用
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(16),
                    //       color: const Color.fromARGB(255, 248, 248, 248),
                    //     ),
                    //     child: ListView.builder(
                    //       physics: const NeverScrollableScrollPhysics(), // 禁用滚动
                    //       shrinkWrap: true, // 让ListView适应子元素大小
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
                    //                 value: selected1[index],
                    //                 onChanged: (value) {
                    //                   setState(() {
                    //                     // _checkedList[index] = value!;
                    //                     selected1[index] = value!;
                    //                   });
                    //                   // 更新总checkbox的选中状态
                    //                   updateAllCheckBoxes();
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
                      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        'Other',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                      child: Column(
                        children: otherData.map((data) {
                          final index = otherData.indexOf(data);
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
                                      value: selected2[index],
                                      onChanged: (value) {
                                        setState(() {
                                          selected2[index] = value!;
                                        });
                                        updateAllCheckBoxes();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (index != otherData.length - 1)
                                const Divider(height: 1),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    // 暂时留下 作为备用
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(16),
                    //       color: const Color.fromARGB(255, 248, 248, 248),
                    //     ),
                    //     child: Column(
                    //       children: otherData.map((data) {
                    //         final index = otherData.indexOf(data);
                    //         return Column(
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   vertical: 8, horizontal: 16),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset(
                    //                     data['img'],
                    //                     width: 40,
                    //                     height: 40,
                    //                   ),
                    //                   const SizedBox(width: 8),
                    //                   Text(data['text']),
                    //                   const Spacer(),
                    //                   Checkbox(
                    //                     value: selected2[index],
                    //                     onChanged: (value) {
                    //                       setState(() {
                    //                         selected2[index] = value!;
                    //                       });
                    //                       updateAllCheckBoxes();
                    //                     },
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             const Divider(),
                    //           ],
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(16),
                    //       color: const Color.fromARGB(255, 248, 248, 248),
                    //     ),
                    //     child: ListView.builder(
                    //       itemCount: otherData.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Column(
                    //           children: [
                    //             ListTile(
                    //               leading: Image.asset(
                    //                 otherData[index]['img'],
                    //                 width: 40, // 设置图片宽度
                    //                 height: 40,
                    //               ),
                    //               title: Text(otherData[index]['text']),
                    //               trailing: Checkbox(
                    //                 value: selected2[index],
                    //                 onChanged: (value) {
                    //                   setState(() {
                    //                     //   _checkedList[index] = value!;
                    //                     // });
                    //                     selected2[index] = value!;
                    //                   });
                    //                   // 更新总checkbox的选中状态
                    //                   updateAllCheckBoxes();
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
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Don't see what you're looking for?",
                            style: TextStyle(
                                color: Color.fromRGBO(136, 135, 135, 1)),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Feedback'),
                                    content: SizedBox(
                                      width: 400.sp,
                                      child: TextFormField(
                                        // controller: lanTimeController,
                                        decoration: const InputDecoration(
                                          labelText: "Feedback...",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Confirm'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _showSnackBar(context,
                                              'Feedback is successful!');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Feedback',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(95, 130, 226, 1)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
