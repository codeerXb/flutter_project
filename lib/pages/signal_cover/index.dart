import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RectController extends GetxController {
  List<RectData> rects = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 返回按钮逻辑
            Get.offNamed('/home');
          },
        ),
        title: const Text('Edit House Layout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // 保存按钮逻辑
              Get.offNamed('/test_signal');
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
                                  rect: const Rect.fromLTWH(
                                    1200, 1200, // 替换为你想要的方块的位置和大小
                                    100, 100,
                                  ),
                                  name: roomName,
                                  floor: curFloor,
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
      ..color = const Color.fromARGB(115, 102, 102, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 计算网格绘制起始位置
    final double startX =
        centerOffset.dx - ((columnCount * cellSize) / 2) + offsetX;
    final double startY =
        centerOffset.dy - ((rowCount * cellSize) / 2) + offsetY;

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

  Offset centerOffset = const Offset(2626, 2626);
  Offset lastOffset = Offset.zero;

  double offsetX = -1000.0;
  double offsetY = -1000.0;
  double maxWidth = 0.0;
  double maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
    // 计算网格的总宽度和高度
    maxWidth = columnCount * cellSize;
    maxHeight = rowCount * cellSize;
  }

  void _updateRectPosition(int index, Offset delta) {
    setState(() {
      final rectData = widget.rects[index];
      rectData.rect = rectData.rect.shift(delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offsetX += details.delta.dx;
          offsetY += details.delta.dy;

          // 限制偏移量范围
          offsetX = offsetX.clamp(-2430, 0);
          offsetY = offsetY.clamp(-2305, 0);
          debugPrint('onPanUpdate: $offsetX,$offsetY');

          // 更新每个矩形的位置
          for (int i = 0; i < widget.rects.length; i++) {
            _updateRectPosition(i, details.delta);
          }
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: offsetX,
            top: offsetY,
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
          // 绘制矩形
          Positioned(
            left: offsetX,
            top: offsetY,
            child: CustomPaint(
              size: Size(maxWidth, maxHeight),
              painter: RectsPainter(widget.rects, widget.curFloor),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  offsetX = -1000;
                  offsetY = -1000;
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
      ),
    );
  }
}

class RectsPainter extends CustomPainter {
  final List<RectData> rects;
  final String curFloor;

  RectsPainter(this.rects, this.curFloor);

  @override
  void paint(Canvas canvas, Size size) {
    for (final rectData in rects) {
      if (curFloor == rectData.floor) {
        final rect = rectData.rect;
        final paint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, paint);

        final textPainter = TextPainter(
          text: TextSpan(
            text: rectData.name,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(rect.left, rect.top),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RectData {
  Rect rect;
  final String name;
  String floor;

  RectData({required this.rect, required this.name, required this.floor});
}
