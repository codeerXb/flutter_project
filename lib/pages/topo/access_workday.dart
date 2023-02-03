import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Workday extends StatefulWidget {
  const Workday({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkdayState();
  }
}

class _WorkdayState extends State<Workday> {
  // String resultMessage = '--';
  String result = '1';

  List<Map<String, dynamic>> checkboxList = [
    {'text': '周一', 'value': false, 'index': 0},
    {'text': '周二', 'value': false, 'index': 1},
    {'text': '周三', 'value': false, 'index': 2},
    {'text': '周四', 'value': false, 'index': 3},
    {'text': '周五', 'value': false, 'index': 4},
    {'text': '周六', 'value': false, 'index': 5},
    {'text': '周日', 'value': false, 'index': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //线性布局
      //子Widget 竖直方向排开
      body: IconButton(
        onPressed: () {
          showBottomSheet();
        },
        icon: const Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }

  //显示底部弹框的功能
  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context);
        },
        context: context);
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    //弹框中内容  310 的调试
    return Column(
      children: [
        buildItem(result, onTap: () {}),

        Padding(padding: EdgeInsets.only(top: 60.sp)),
        //   //取消按钮
        //   //添加个点击事件
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 44.sp,
              alignment: Alignment.center,
              child: const Text("取消"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop(checkboxList);
              print('---qqqq-----$checkboxList');
            },
            child: Container(
              alignment: Alignment.center,
              child: const Text("确定"),
            ),
          )
        ])
      ],
    );
  }

  Widget buildItem(String title, {onTap}) {
    //添加点击事件
    return StatefulBuilder(
        builder: (context, void Function(void Function()) setState) {
      return InkWell(
          //点击回调
          onTap: () {
            //关闭弹框
            Navigator.of(context).pop();
            //外部回调
            if (onTap != null) {
              onTap();
            }
          },
          child: SizedBox(
              height: 460.sp,
              child: Column(
                children: checkboxList
                    .map((item) => Flexible(
                          child: CheckboxListTile(
                            title: Text('${item['text']}'),
                            value: item['value'],
                            activeColor: Colors.blueAccent,
                            isThreeLine: false,
                            dense: false,
                            selected: false,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (data) {
                              setState(() {
                                checkboxList[item['index']]['value'] = data;
                                print(
                                    '-----测试8----${checkboxList[item['index']]}');
                              });
                            },
                          ),
                        ))
                    .toList(),
              )));
    });
  }
}
