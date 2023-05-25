import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';

// 将接收的json转化成List<RectData>
List<RectData> convertToRectDataList(List<dynamic> dataList) {
  List<RectData> rectDataList = [];

  for (var dataItem in dataList) {
    final data = dataItem as Map<String, dynamic>;
    RectData rectData = RectData(
      name: data['name'],
      floor: data['floor'],
      isSelected: data['isSelected'],
      offsetX: data['offsetX'],
      offsetY: data['offsetY'],
      left: data['left'],
      top: data['top'],
      width: data['width'],
      height: data['height'],
    );

    rectDataList.add(rectData);
  }

  return rectDataList;
}

class RectController extends GetxController {
  List<RectData> rects = [];

  void init() async {
    var sn = await sharedGetData('deviceSn', String);
    var res = await App.get('/platform/wifiJson/getOne/$sn');
    debugPrint(res['wifiJson']['list'].toString());
    rects = convertToRectDataList(res['wifiJson']['list']);
    update();
  }

  void addRect(RectData rect) {
    rects.add(rect);
    update(); // 通知监听器刷新界面
  }

  void clearRect() {
    rects.clear();
    update();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> floors = ['1F'];
  bool isGridExpanded = false;
  String editingFloor = '';
  // 使用RectController来管理_rects
  final RectController _rectController = Get.put(RectController());
  String _currentRectName = '';
  String roomName = '';
  // 当前选中的楼层
  String curFloor = '1F';

  void renameFloor(BuildContext context, int index) {
    editingFloor = floors[index]; // 将选中的楼层名称赋值给editingFloor变量
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: StatefulBuilder(
            // 使用StatefulBuilder包裹对话框内容以更新状态
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Rename'),
                    onTap: () {
                      // 不需要在这里做任何操作，等待对话框关闭后处理
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('CANCEL'),
                    onTap: () {
                      deleteFloor(index);
                      Navigator.pop(context);
                    },
                  ),
                  TextFormField(
                    // 添加文本输入框
                    initialValue: editingFloor, // 初始值为editingFloor
                    onChanged: (value) {
                      setState(() {
                        editingFloor = value; // 更新editingFloor的值
                      });
                    },
                  ),
                  ElevatedButton(
                    // 添加确认按钮
                    onPressed: () {
                      // 更新楼层名称为编辑后的值
                      floors[index] = editingFloor;
                      setState(() {}); // 刷新界面
                      Navigator.pop(context); // 关闭对话框
                    },
                    child: Text('CONFIRM'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
    Navigator.pop(context);
  }

  void deleteFloor(index) {
    // 实现删除逻辑
    floors.remove(floors[index]);
    setState(() {});
  }

  void addFloor() {
    // 匹配最后一个楼层字符串的数字
    String digit = floors[floors.length - 1].replaceAll(RegExp(r'[^0-9]'), '');
    int nextFloorNumber = int.parse(digit) + 1;
    floors.add('$nextFloorNumber' 'F');
    setState(() {});
  }

  // saveLoading
  bool saveLayoutLoading = false;
  void onSaveLayout() async {
    setState(() {
      saveLayoutLoading = true;
    });
    try {
      var sn = await sharedGetData("deviceSn", String);
      debugPrint('devicesn: $sn');
      // 实现保存户型图逻辑
      await App.post('/platform/wifiJson/wifi', data: {
        "sn": sn,
        "wifiJson": {"list": _rectController.rects}
      });
      printInfo(
          info:
              '户型数据：${jsonEncode({"list": _rectController.rects}).toString()}');
      Get.offNamed('/test_signal');
    } catch (err) {
      printError(info: err.toString());
    } finally {
      setState(() {
        saveLayoutLoading = false;
      });
    }
  }

  // 重置户型图
  void onResetRects() {
    _rectController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 返回按钮逻辑
            Get.back();
          },
        ),
        title: const Text('Edit House Layout'),
        actions: [
          IconButton(
            icon: saveLayoutLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.save),
            onPressed: () {
              saveLayoutLoading ? null : onSaveLayout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: floors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      String floor = floors[index];
                      return GestureDetector(
                        onTap: () {
                          // 判断是否选中了这个楼层
                          if (floor != curFloor) {
                            // 未选中改变curFloor
                            setState(() {
                              curFloor = floor;
                            });
                          } else {
                            // 选中展开抽屉操作菜单
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('RENAME'),
                                        onTap: () {
                                          renameFloor(context, index);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      if (index != 0)
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('DELETE'),
                                          onTap: () {
                                            deleteFloor(index);
                                            Navigator.pop(context);
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10.w, top: 10.w, bottom: 10.w),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: floor == curFloor
                                ? const Color.fromARGB(57, 70, 88, 255)
                                : const Color.fromARGB(255, 255, 255, 255),
                            border: floor == curFloor
                                ? Border.all(
                                    color:
                                        const Color.fromARGB(255, 13, 153, 247),
                                    width: 2)
                                : Border.all(
                                    color: Colors.black, width: 1), // 添加黑色边框
                          ),
                          child: Text(
                            floor,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                    onTap: (() => addFloor()),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white, // 将背景色改为白色
                        border:
                            Border.all(color: Colors.black, width: 2), // 添加黑色边框
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add,
                          color: Colors.black, // 将字体颜色改为黑色
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<RectController>(
              builder: (_) =>
                  GridWidget(rects: _rectController.rects, curFloor: curFloor),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add Room'),
                        content: TextFormField(
                          initialValue: roomName,
                          onChanged: (value) {
                            setState(() {
                              roomName = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Room Name',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('ADD'),
                            onPressed: () {
                              // 在此处处理确认按钮的逻辑
                              if (roomName.isNotEmpty) {
                                // 创建一个方块数据对象
                                final rectData = RectData(
                                  left: 0,
                                  top: 0,
                                  width: 100,
                                  height: 100,
                                  name: roomName,
                                  floor: curFloor,
                                  isSelected: false,
                                  // 相对（0，0）的正向偏移
                                  offsetX: 1200.0,
                                  offsetY: 1200.0,
                                );

                                // 将方块数据添加到列表中
                                _rectController.addRect(rectData);

                                // 清空输入的文字
                                setState(() {
                                  roomName = '';
                                });
                                // 关闭对话框
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    Text('Add Room'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 按钮点击逻辑
                  _rectController.clearRect();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.clear),
                    Text('Clear'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 按钮点击逻辑
                  onResetRects();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.settings_backup_restore),
                    Text('Reset'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int rowCount;
  final int columnCount;
  final double cellSize;
  final Offset centerOffset;
  final double offsetX;
  final double offsetY;

  GridPainter({
    required this.rowCount,
    required this.columnCount,
    required this.cellSize,
    required this.centerOffset,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 196, 196, 196)
      ..style = PaintingStyle.stroke;
    final paintBlack = Paint()
      ..color = const Color.fromARGB(255, 151, 151, 151)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 计算网格绘制起始位置
    final double startX = centerOffset.dx + offsetX;
    final double startY = centerOffset.dy + offsetY;

    // 绘制垂直线
    for (int i = 0; i <= columnCount; i++) {
      final x = startX + (i * cellSize);
      // 每5格绘制一条分割线（粗一点颜色深一点的线）
      if (i % 5 == 0) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, startY + (rowCount * cellSize)),
          paintBlack,
        );
      } else {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, startY + (rowCount * cellSize)),
          paint,
        );
      }
    }

    // 绘制水平线
    for (int i = 0; i <= rowCount; i++) {
      final y = startY + (i * cellSize);
      // 每5格绘制一条分割线（粗一点颜色深一点的线）
      if (i % 5 == 0) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + (columnCount * cellSize), y),
          paintBlack,
        );
      } else {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + (columnCount * cellSize), y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return rowCount != oldDelegate.rowCount ||
        columnCount != oldDelegate.columnCount ||
        cellSize != oldDelegate.cellSize ||
        centerOffset != oldDelegate.centerOffset;
  }
}

class GridWidget extends StatefulWidget {
  final List<RectData> rects; // 在构造函数中接收_rects
  final String curFloor;

  const GridWidget({Key? key, required this.rects, required this.curFloor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  final int rowCount = 350;
  final int columnCount = 350;
  final double cellSize = 15.0;

  Offset centerOffset = const Offset(0, 0);
  Offset lastOffset = Offset.zero;

  double offsetX = -1200;
  double offsetY = -1200;
  double maxWidth = 0.0;
  double maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
    // 计算网格的总宽度和高度
    maxWidth = columnCount * cellSize;
    maxHeight = rowCount * cellSize;
  }

  @override
  Widget build(BuildContext context) {
    final rectWidgets = <Widget>[];
    for (final rectData in widget.rects) {
      if (widget.curFloor == rectData.floor) {
        rectWidgets.add(
          Positioned(
            left: offsetX + rectData.offsetX,
            top: offsetY + rectData.offsetY,
            child: GestureDetector(
              // behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  // 将原有的所有的isSelected重置
                  for (var rect in widget.rects) {
                    rect.isSelected = false;
                  }
                  // 将现在点击的变为选中
                  rectData.isSelected = !rectData.isSelected;
                  if (rectData.isSelected) {}
                });
              },
              onPanUpdate: (details) {
                if (rectData.isSelected) {
                  printInfo(info: '方块：${details.delta}');
                  setState(() {
                    rectData.offsetX += details.delta.dx;
                    rectData.offsetY += details.delta.dy;
                    printInfo(
                        info: '方块位置：${rectData.offsetX},${rectData.offsetY}');
                    // // 限制偏移范围
                    // rectData.offsetX =
                    //     rectData.offsetX.clamp(0, 2430 - rectData.rect.width);
                    // rectData.offsetY =
                    //     rectData.offsetX.clamp(0, 2305 - rectData.rect.height);
                  });
                }
              },
              child: CustomPaint(
                size: const Size(100, 100),
                painter: RectsPainter(rectData),
              ),
            ),
          ),
        );
      }
    }
    return Stack(
      children: [
        // 画布
        Positioned(
          left: offsetX,
          top: offsetY,
          child: GestureDetector(
            onTap: () {
              // 将原有的所有的isSelected重置
              for (var rect in widget.rects) {
                setState(() {
                  rect.isSelected = false;
                });
              }
            },
            onPanUpdate: (details) {
              setState(() {
                offsetX += details.delta.dx;
                offsetY += details.delta.dy;

                // 限制偏移量范围
                offsetX = offsetX.clamp(-2430, 0);
                offsetY = offsetY.clamp(-2305, 0);
                debugPrint('onPanUpdate: $offsetX,$offsetY');

                // // 更新每个矩形的位置
                // for (int i = 0; i < widget.rects.length; i++) {
                //   _updateRectPosition(i, details.delta);
                // }
              });
            },
            child: CustomPaint(
              size: Size(maxWidth, maxHeight),
              painter: GridPainter(
                offsetX: offsetX,
                offsetY: offsetY,
                rowCount: rowCount,
                columnCount: columnCount,
                cellSize: cellSize,
                centerOffset: centerOffset,
              ),
            ),
          ),
        ),
        // 绘制矩形
        ...rectWidgets,
        // 复位操作按钮
        Positioned(
          bottom: 0,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                offsetX = -1200;
                offsetY = -1200;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Icon(Icons.settings_backup_restore),
          ),
        ),
      ],
    );
  }
}

class RectsPainter extends CustomPainter {
  final RectData rectData;

  RectsPainter(this.rectData);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
        rectData.left, rectData.top, rectData.width, rectData.height);
    final isSelected = rectData.isSelected;
    final paint = Paint()
      ..color = isSelected
          ? const Color.fromARGB(255, 0, 89, 255)
          : const Color.fromARGB(255, 0, 0, 0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: rectData.name,
        style: const TextStyle(color: Colors.black, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: rect.width / 4 * 3);
    final textOffset = Offset(
      rect.left + (rect.width - textPainter.width) / 2,
      rect.top + (rect.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(RectsPainter oldDelegate) {
    return true;
  }
}

class RectData {
  final String name;
  String floor;
  bool isSelected;
  double offsetX;
  double offsetY;
  double left;
  double top;
  double width;
  double height;

  RectData({
    required this.name,
    required this.floor,
    required this.isSelected,
    required this.offsetX,
    required this.offsetY,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'floor': floor,
      'isSelected': isSelected,
      'offsetX': offsetX,
      'offsetY': offsetY,
    };
  }
}
