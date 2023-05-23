import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/left_slide_actions.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

class Blocklist extends StatefulWidget {
  const Blocklist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocklistState();
}

class _BlocklistState extends State<Blocklist> {
  static const int _itemNum = 5;
  final List<String> _itemTextList = [];
  final Map<String, VoidCallback> _mapForHideActions = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= _itemNum; i++) {
      _itemTextList.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Website Blocklist'),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
            ),
            // 列表
            if (_itemTextList.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(5.0),
                height: 890.w,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
                  itemCount: _itemTextList.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    if (index < _itemTextList.length) {
                      final String tempStr = _itemTextList[index];
                      return LeftSlideActions(
                        key: Key(tempStr),
                        actionsWidth: 120,
                        actions: [
                          _buildChangeBtn(index),
                          _buildDeleteBtn(index)
                        ],
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        actionsWillShow: () {
                          // 隐藏其他列表项的行为。
                          for (int i = 0; i < _itemTextList.length; i++) {
                            if (index == i) {
                              continue;
                            }
                            String tempKey = _itemTextList[i];
                            VoidCallback? hideActions =
                                _mapForHideActions[tempKey];
                            if (hideActions != null) {
                              hideActions();
                            }
                          }
                        },
                        exportHideActions: (hideActions) {
                          _mapForHideActions[tempStr] = hideActions;
                        },
                        child: _buildListItem(index),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  // 添加下面这句 内容未充满的时候也可以滚动。
                  physics: const AlwaysScrollableScrollPhysics(),
                  // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
                  //shrinkWrap: true,
                ),
              ),

            if (!_itemTextList.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(5.0),
                height: 890.w,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.content_paste,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text('No URLs'),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 25.sp),
            ),
            // + 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xffffffff)), //背景颜色
                    foregroundColor: MaterialStateProperty.all(
                        const Color(0xff5E6573)), //字体颜色
                    overlayColor: MaterialStateProperty.all(
                        const Color(0xffffffff)), // 高亮色
                    shadowColor: MaterialStateProperty.all(
                        const Color(0xffffffff)), //阴影颜色
                    elevation: MaterialStateProperty.all(0), //阴影值
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 12)), //字体
                    side: MaterialStateProperty.all(const BorderSide(
                        width: 1, color: Color(0xffCAD0DB))), //边框
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ), //圆角弧度
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Add'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: 'URL',
                                  hintText: 'https://example.com',
                                ),
                                onChanged: (value) {
                                  url = value;
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(S.current.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Text(S.current.confirm),
                              onPressed: () {
                                // 在这里处理确定按钮的逻辑
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // Get.toNamed("/parental_pop", arguments: data)
                    //     ?.then((value) => getAccessList());
                  },
                  child: Text("Add", style: TextStyle(fontSize: 30.sp)),
                )
              ],
            ),
          ]),
        )),
      ),
    );
  }

  Widget _buildListItem(final int index) {
    return Container(
        height: 130.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // 阴影颜色。
              color: Color(0x66EBEBEB),
              // 阴影xy轴偏移量。
              offset: Offset(0.0, 0.0),
              // 阴影模糊程度。
              blurRadius: 6.0,
              // 阴影扩散程度。
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.sp),
            ),
            Text('3',
                // '${accessList.fwParentControlTable![index].timeStart!}${S.current.to}${accessList.fwParentControlTable![index].timeStop!}${S.current.access}',
                style: TextStyle(
                    color: const Color.fromARGB(255, 5, 0, 0),
                    fontSize: ScreenUtil().setWidth(30.0))),
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
            ),
            Text('4',
                // accessList.fwParentControlTable![index].weekdays.toString(),
                style: TextStyle(
                    color: const Color.fromRGBO(147, 148, 168, 1),
                    fontSize: ScreenUtil().setWidth(28.0))),
          ],
        ));
  }

  Widget _buildDeleteBtn(final int index) {
    return GestureDetector(
      onTap: () {
        _openAvatarBottomSheet();
        setState(() {
          // del = accessList.fwParentControlTable![index].id!;
        });
      },
      child: Container(
        width: 60,
        color: const Color(0xFFF20101),
        alignment: Alignment.center,
        child: Text(
          S.current.delete,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }

  // 删除
  _openAvatarBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 260.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w))),
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.w),
                              topRight: Radius.circular(30.w))),
                      height: 80.w,
                      alignment: Alignment.center,
                      child: Text(
                        S.current.hint,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 60.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        S.current.delPro,
                        style:
                            TextStyle(color: Colors.black45, fontSize: 22.sp),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.w)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: 0.5.sw - 30.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            S.current.cancel,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          // getAccessDel();
                        },
                        child: Container(
                          height: 60.w,
                          width: 0.5.sw - 30.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            S.current.confirm,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  String url = '';
  // 修改
  Widget _buildChangeBtn(final int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      hintText: 'https://example.com',
                    ),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.current.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(S.current.confirm),
                  onPressed: () {
                    // 在这里处理确定按钮的逻辑
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 60,
        color: Colors.green,
        alignment: Alignment.center,
        child: Text(
          S.current.modification,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// add 弹窗
// class AddUrl extends StatefulWidget {
//   @override
//   AddUrlState createState() => AddUrlState();
// }

// class AddUrlState extends State<AddUrl> {
//   final TextEditingController _urlController = TextEditingController();

//   @override
//   void dispose() {
//     _urlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: const InputDecoration(
//                 labelText: 'URL',
//                 hintText: 'https://example.com',
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(S.current.cancel),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             String url = _urlController.text;
//             // Do something with the URL
//             Navigator.pop(context);
//           },
//           child: Text(S.current.confirm),
//         ),
//       ],
//     );
//   }
// }
