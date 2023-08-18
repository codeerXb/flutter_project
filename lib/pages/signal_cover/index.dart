import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

// 将接收的json转化成List<RectData>
List<RectData> convertToRectDataList(List<dynamic> dataList) {
  List<RectData> rectDataList = [];

  for (var dataItem in dataList) {
    final data = dataItem as Map<String, dynamic>;
    RectData rectData = RectData(
      floorId: data['floorId'],
      name: data['name'],
      floor: data['floor'],
      isSelected: data['isSelected'],
      offsetX: data['offsetX'],
      offsetY: data['offsetY'],
      left: data['left'],
      top: data['top'],
      width: data['width'],
      height: data['height'],
      selectedEdge: data['selectedEdge'],
      snr: data['snr'] ?? '',
      noiseLevel: data['NoiseLevel'] ?? '',
      txPower: data['txPower'] ?? '',
      routerX: data['routerX'] ?? 0.0,
      routerY: data['routerY'] ?? 0.0,
      roomArea: data['roomArea'] ?? 0,
    );

    rectDataList.add(rectData);
  }

  return rectDataList;
}

// 将接收的json转化成floors
List<Map<String, String>> getUniqueFloors(List<dynamic> data) {
  // 对floorId去重
  var uniqueIds = data.map((e) => e['floorId']).toSet();
  // 得到楼层数据
  List<Map<String, String>> uniqueFloor = data
      .where((e) => uniqueIds.remove(e['floorId']))
      .map(
          (e) => {'id': e['floorId'].toString(), 'name': e['floor'].toString()})
      .toList();
  uniqueFloor
      .sort((a, b) => int.parse(a['id']!).compareTo(int.parse(b['id']!)));
  return uniqueFloor;
}

class RectController extends GetxController {
  List<RectData> rects = [];

  void init(res) {
    rects = convertToRectDataList(res['wifiJson']['list']);
    update();
  }

  void addRect(RectData rect) {
    rects.add(rect);
    update(); // 通知监听器刷新界面
  }

  void clearRect(String floorId) {
    rects = rects.where((element) => element.floorId != floorId).toList();
    update();
  }

  // 清除rect的isSelected和selectedEdge状态
  void clearRectStatus() {
    for (var rect in rects) {
      rect.isSelected = false;
      rect.selectedEdge = '';
    }
    update();
  }

  //更新面积
  void updateArea(newRoomArea) {
    var currentFloor = rects
        .where((element) => element.floorId == curFloorId.toString())
        .toList();
    for (var element in currentFloor) {
      element.roomArea = int.parse(newRoomArea);
    }
    update();
  }
}

String curFloorId = '1';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 定义楼层数据
  List<Map<String, String>> floors = [
    {'id': '1', 'name': '1F'}
  ];
  bool isGridExpanded = false;
  String editingFloor = '';
  String editingFloorId = '';
  // 使用RectController来管理_rects
  final RectController _rectController = Get.put(RectController());
  String roomName = '';
  var roomArea = '100';
  // 当前选中的楼层
  String curFloor = '1F';
  bool returnHomePage = false; //是否返回首页

  Future<dynamic> getData() async {
    try {
      var sn = await sharedGetData('deviceSn', String);
      var res = await App.get('/platform/wifiJson/getOne/$sn');
      return res;
    } catch (err) {
      debugPrint(err.toString());
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    returnHomePage = Get.arguments['homepage'];
    getData().then((value) {
      if (value != null) {
        if (getUniqueFloors(value['wifiJson']['list']).isNotEmpty) {
          setState(() {
            floors = getUniqueFloors(value['wifiJson']['list']);
          });
        }
        _rectController.init(value);
      }
    });
  }

  // --- 重命名楼层 ---
  void renameFloor(BuildContext context, int index) {
    editingFloor = floors[index]['name']!; // 将选中的楼层名称赋值给editingFloor变量
    editingFloorId = floors[index]['id']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Floor'),
          content: TextFormField(
            initialValue: editingFloor,
            onChanged: (value) {
              setState(() {
                editingFloor = value;
              });
            },
            // decoration: const InputDecoration(
            //   labelText: 'Room Name',
            // ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                // 在此处处理确认按钮的逻辑
                floors[index]['name'] = editingFloor;
                // 清空输入的文字
                setState(() {
                  curFloor = editingFloor;
                  curFloorId = floors[index]['id']!;
                  // 修改同一个floorId下面的floor
                  List<dynamic> wifiList = _rectController.rects;
                  wifiList
                      .where((wifi) => wifi.floorId == editingFloorId)
                      .forEach((wifi) => wifi.floor = editingFloor);
                });
                // 关闭对话框
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --- 删除楼层 ---
  void deleteFloor(index) {
    printInfo(info: '删除的楼层$floors,索引$index,值${floors[index]['id']}');
    // 实现删除逻辑
    setState(() {
      // 删除对应的户型图
      _rectController.clearRect(floors[index]['id'].toString());
      floors.remove(floors[index]);
    });
  }

  // --- 添加楼层 ---
  void addFloor() {
    // 找出floors中的最大id
    var maxId = floors.reduce((cur, next) =>
        int.parse(cur['id']!) > int.parse(next['id']!) ? cur : next)['id'];
    // id++
    int nextFloorNumber = int.parse(maxId!) + 1;
    floors.add({'id': '$nextFloorNumber', 'name': '$nextFloorNumber' 'F'});
    // 创建一个方块数据对象
    final rectData = RectData(
      floorId: '$nextFloorNumber',
      left: 0,
      top: 0,
      width: 100,
      height: 100,
      name: 'Room',
      floor: '$nextFloorNumber' 'F',
      isSelected: false,
      // 相对（0，0）的正向偏移
      offsetX: 1250.0,
      offsetY: 1250.0,
      selectedEdge: '',
    );
    setState(() {
      // 初始化楼层的时候创建一个方块
      _rectController.addRect(rectData);
    });
  }

  // saveLoading
  bool saveLayoutLoading = false;
  void onSaveLayout() {
    //当前楼层面积
    var currentFloor = _rectController.rects
        .where((element) => element.floorId == curFloorId.toString())
        .toList();
    for (var element in currentFloor) {
      roomArea = element.roomArea.toString();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Room Area(㎡)'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: roomArea,
            onChanged: (value) {
              setState(() {
                roomArea = value;
              });
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () async {
                if (roomArea.isNotEmpty) {
                  // 修改面积
                  _rectController.updateArea(roomArea);

                  // 聚焦
                  focusFloor(_rectController.rects, curFloorId, setState);
                  setState(() {
                    saveLayoutLoading = true;
                  });
                  try {
                    var sn = await sharedGetData("deviceSn", String);
                    // 保存的时候清除isSelected和selectedEdge状态
                    _rectController.clearRectStatus();
                    // 实现保存户型图逻辑
                    await App.post('/platform/wifiJson/wifi', data: {
                      "sn": sn,
                      "wifiJson": {"list": _rectController.rects}
                    });
                    // 关闭对话框
                    Navigator.of(context).pop();
                    printInfo(
                        info: '户型数据：${jsonEncode(_rectController.rects)}');
                    Get.offNamed(
                      '/test_signal',
                      arguments: {
                        'roomInfo': jsonEncode(_rectController.rects),
                        'curFloorId': curFloorId
                      },
                    );
                  } catch (err) {
                    printError(info: err.toString());
                  } finally {}
                  // 清空输入的文字
                  setState(() {
                    // roomArea = '';
                    saveLayoutLoading = false;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 重置户型图
  void onResetRects() {
    getData().then((value) {
      if (value != null) {
        _rectController.init(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            if (returnHomePage) {
              Get.back();
            } else {
              Get.offNamed('/test_edit');
            }
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
          SizedBox(
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
                      String? floor = floors[index]['name'];
                      String? floorId = floors[index]['id'];
                      return GestureDetector(
                        onTap: () {
                          // 判断是否选中了这个楼层
                          if (floorId != curFloorId) {
                            // 未选中改变curFloor
                            setState(() {
                              curFloor = floor!;
                              curFloorId = floors[index]['id']!;
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
                                        leading: const Icon(Icons.edit),
                                        title: const Text('RENAME'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          renameFloor(context, index);
                                        },
                                      ),
                                      if (index != 0)
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('DELETE'),
                                          onTap: () {
                                            // 删除当前楼层
                                            deleteFloor(index);
                                            // 重新选中1F
                                            setState(() {
                                              curFloorId = '1';
                                            });
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
                            color: floorId == curFloorId
                                ? const Color.fromARGB(57, 70, 88, 255)
                                : const Color.fromARGB(255, 255, 255, 255),
                            border: floorId == curFloorId
                                ? Border.all(
                                    color:
                                        const Color.fromARGB(255, 13, 153, 247),
                                    width: 2)
                                : Border.all(
                                    color: Colors.black, width: 1), // 添加黑色边框
                          ),
                          child: Text(
                            floor!,
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
              builder: (_) => GridWidget(
                  rects: _rectController.rects, curFloorId: curFloorId),
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
              child: OutlinedButton(
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
                                  floorId: curFloorId,
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
                                  selectedEdge: '',
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
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // set border radius to 0
                  ),
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
              child: OutlinedButton(
                onPressed: () {
                  // 按钮点击逻辑
                  // 清空当前楼层
                  _rectController.clearRect(curFloorId);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // set border radius to 0
                  ),
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
              child: OutlinedButton(
                onPressed: () {
                  // 按钮点击逻辑
                  onResetRects();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // set border radius to 0
                  ),
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
      ..color = const Color.fromARGB(255, 197, 197, 197)
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
  final String curFloorId;

  const GridWidget({Key? key, required this.rects, required this.curFloorId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GridWidgetState();
}

// 聚焦
void focusFloor(rects, curFloorId, setState) {
  // TODO:根据实际的方块所在的位置进行聚焦
  // 找出floorId为1的所有数据
  var filteredData = rects.where((item) => item.floorId == curFloorId).toList();

  /// 思路：
  /// 只需要将每个值的偏移量都大于1200即可
  /// 需要计算的就是可以让每个值都大于1200的值
  /// 只要找出所有x中最小的值，计算出与1200的差值就是每个x需要加的值
  /// y亦然

  double findMin(String value) {
    double min = double.infinity;

    for (var item in filteredData) {
      if (item.toJson()[value] < min) {
        min = item.toJson()[value];
      }
    }
    return min;
  }

  // --- 算出差值 ---
  // 找出最大的offsetX值
  double maxX = findMin('offsetX');
  // x差值
  double diffX = 1200 - maxX;

  // 找出最大的offsetY值
  double maxY = findMin('offsetY');
  // y差值
  double diffY = 1200 - maxY;

  // --- 更新位置 ---
  for (var item in filteredData) {
    setState(() {
      item.offsetX = item.offsetX + diffX;
      item.offsetY = item.offsetY + diffY;
    });
  }
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

  // 定义选中的边
  String selectedEdge = '';
  // 修改home名字
  String editRoomName = '';
  @override
  void initState() {
    super.initState();
    // 计算网格的总宽度和高度
    maxWidth = columnCount * cellSize;
    maxHeight = rowCount * cellSize;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('户型:$offsetX,$offsetY');
    final rectWidgets = <Widget>[];
    for (final rectData in widget.rects) {
      if (widget.curFloorId == rectData.floorId) {
        debugPrint(
            '户型内部offset:${rectData.offsetX},${rectData.offsetY}++$offsetX,$offsetY');
        debugPrint("--------------");
        rectWidgets.add(
          Positioned(
            // 保证绝对定位的偏移量和画布重绘的偏移量一致
            left: offsetX,
            top: offsetY,
            // 相对定位
            child: Transform.translate(
              offset: Offset(rectData.offsetX, rectData.offsetY),
              child: GestureDetector(
                // behavior: HitTestBehavior.opaque,
                onPanDown: (details) {
                  for (var rect in widget.rects) {
                    setState(() {
                      // 将原有的所有的isSelected重置
                      rect.isSelected = false;
                      // 将原有的所有选中的边重置
                      rect.selectedEdge = '';
                    });
                  }
                  // 将现在点击的变为选中
                  if (details.localPosition.dx < 15 &&
                      details.localPosition.dy > 15 &&
                      details.localPosition.dy < rectData.height - 15) {
                    // 点击左边缘
                    setState(() {
                      rectData.selectedEdge = 'left';
                    });
                  } else if (details.localPosition.dx > 15 &&
                      details.localPosition.dx < rectData.width - 15 &&
                      details.localPosition.dy < 15) {
                    // 点击上边缘
                    setState(() {
                      rectData.selectedEdge = 'top';
                    });
                  } else if (details.localPosition.dx > rectData.width - 15 &&
                      details.localPosition.dy > 15 &&
                      details.localPosition.dy < rectData.height - 15) {
                    // 点击右边缘
                    setState(() {
                      rectData.selectedEdge = 'right';
                    });
                  } else if (details.localPosition.dy > rectData.height - 15 &&
                      details.localPosition.dx > 15 &&
                      details.localPosition.dx < rectData.width - 15) {
                    // 点击下边缘
                    setState(() {
                      rectData.selectedEdge = 'bottom';
                    });
                  } else {
                    setState(() {
                      rectData.selectedEdge = '';
                    });
                  }
                  setState(() {
                    rectData.isSelected = true;
                  });
                  debugPrint(
                      'onPanDown:${details.localPosition}||${details.globalPosition}||${offsetX + rectData.offsetX}--${rectData.width}--${rectData.height}');
                },
                onPanUpdate: (details) {
                  debugPrint(
                      'onPanUpdate INNER: ${details.delta.dx},${details.delta.dy}');
                  if (rectData.isSelected) {
                    printInfo(info: '方块：${details.delta}');
                    setState(() {
                      // // 限制偏移范围
                      // rectData.offsetX =
                      //     rectData.offsetX.clamp(0, 2430 - rectData.rect.width);
                      // rectData.offsetY =
                      //     rectData.offsetX.clamp(0, 2305 - rectData.rect.height);

                      if (rectData.selectedEdge == 'top') {
                        // 拖拽上边缘
                        // change top & height
                        if (rectData.height - details.delta.dy > 15) {
                          rectData.offsetY += details.delta.dy;
                          rectData.height -= details.delta.dy;
                        }
                        Vibration.vibrate(duration: 20, amplitude: 225);
                      } else if (rectData.selectedEdge == 'left') {
                        // 拖拽左边缘
                        // change left & width
                        if (rectData.width - details.delta.dx > 15) {
                          rectData.offsetX += details.delta.dx;
                          rectData.width -= details.delta.dx;
                        }
                        Vibration.vibrate(duration: 20, amplitude: 225);
                      } else if (rectData.selectedEdge == 'right') {
                        // 拖拽右边缘
                        // change width
                        if (rectData.width + details.delta.dx > 15) {
                          rectData.width += details.delta.dx;
                        }
                        Vibration.vibrate(duration: 20, amplitude: 225);
                      } else if (rectData.selectedEdge == 'bottom') {
                        // 拖拽下边缘
                        // change height
                        if (rectData.height + details.delta.dy > 15) {
                          rectData.height += details.delta.dy;
                        }
                        Vibration.vibrate(duration: 20, amplitude: 225);
                      } else {
                        // 拖拽其他地方
                        rectData.offsetX += details.delta.dx;
                        rectData.offsetY += details.delta.dy;
                        // 触发短促有力的震动
                        Vibration.vibrate(duration: 50, amplitude: 255);
                      }
                    });
                  }
                },
                // 长按选中之后弹窗  修改home值  删除方块
                onLongPress: () {
                  if (rectData.selectedEdge == '') {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Edit Room'),
                                        content: TextFormField(
                                          initialValue: rectData.name,
                                          onChanged: (value) {
                                            setState(() {
                                              editRoomName = value;
                                            });
                                          },
                                          // decoration: const InputDecoration(
                                          //   labelText: 'Room Name',
                                          // ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('CANCEL'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Edit'),
                                            onPressed: () {
                                              rectData.name = editRoomName;
                                              // 在此处处理确认按钮的逻辑
                                              // 清空输入的文字
                                              setState(() {
                                                editRoomName = '';
                                              });
                                              // 关闭对话框
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    widget.rects.remove(rectData);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    // 其他情况下就是点击边缘时触发
                    // 长按边缘可以删除选中的边缘
                    // 也可以长按边缘拆除墙面
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Split Wall'),
                                onTap: () {
                                  // 拆墙添加一个中心点
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete Wall'),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    widget.rects.remove(rectData);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: CustomPaint(
                  size: Size(rectData.width, rectData.height),
                  painter: RectsPainter(rectData),
                ),
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
          // 让画布偏移量和布局偏移一致
          left: offsetX,
          top: offsetY,
          child: GestureDetector(
            onTap: () {
              // 将原有的所有的isSelected,selectedEdge重置
              for (var rect in widget.rects) {
                setState(() {
                  rect.isSelected = false;
                  rect.selectedEdge = '';
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
                debugPrint(
                    '网格onPanUpdate OUT: ${details.delta.dx},${details.delta.dy}');
                debugPrint('网格onPanUpdate offset: $offsetX,$offsetY');

                // // 更新每个矩形的位置
                // for (int i = 0; i < widget.rects.length; i++) {
                //   _updateRectPosition(i, details.delta);
                // }
              });
            },
            child: CustomPaint(
              size: Size(maxWidth, maxHeight),
              painter: GridPainter(
                // 画布一次性绘制不再发生改变
                offsetX: 0,
                offsetY: 0,
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
        // 复位操作按钮，聚焦操作
        Positioned(
          bottom: 0,
          left: 10,
          child: ElevatedButton(
            onPressed: () {
              focusFloor(widget.rects, widget.curFloorId, setState);

              // --- 视角依然聚焦到-1200 ---
              setState(() {
                offsetX = -1150;
                offsetY = -1150;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Icon(Icons.center_focus_weak_rounded),
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
    final paintFill = Paint()
      ..strokeWidth = 2
      ..color = const Color.fromARGB(112, 237, 237, 237)
      ..style = PaintingStyle.fill;
    // 绘制选中边线的画笔
    final paintEdge = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // canvas.drawRect(rect, paint);
    // 绘制路径填充颜色
    // 1.创建路径
    Path path = Path();
    path.moveTo(rect.topLeft.dx, rect.topLeft.dy);
    path.lineTo(rect.topRight.dx, rect.topRight.dy);
    path.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
    path.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    path.close();
    // 2.canvas填充颜色
    canvas.drawPath(path, paintFill);

    // 沿着路径绘制线，选中更换画笔
    canvas.drawLine(rect.topLeft, rect.topRight,
        rectData.selectedEdge == 'top' ? paintEdge : paint);
    canvas.drawLine(rect.topRight, rect.bottomRight,
        rectData.selectedEdge == 'right' ? paintEdge : paint);
    canvas.drawLine(rect.bottomRight, rect.bottomLeft,
        rectData.selectedEdge == 'bottom' ? paintEdge : paint);
    canvas.drawLine(rect.bottomLeft, rect.topLeft,
        rectData.selectedEdge == 'left' ? paintEdge : paint);

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
  String name;
  String floor;
  bool isSelected;
  double offsetX;
  double offsetY;
  double left;
  double top;
  double width;
  double height;
  String selectedEdge;
  String floorId;
  String snr;
  String noiseLevel;
  String txPower;
  double routerX;
  double routerY;
  int roomArea;

  RectData({
    required this.floorId,
    required this.name,
    required this.floor,
    required this.isSelected,
    required this.offsetX,
    required this.offsetY,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.selectedEdge,
    this.snr = '',
    this.noiseLevel = '',
    this.txPower = '',
    this.routerX = 0.0,
    this.routerY = 0.0,
    this.roomArea = 0,
  });
  Map<String, dynamic> toJson() {
    return {
      'floorId': floorId,
      'name': name,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'floor': floor,
      'isSelected': isSelected,
      'offsetX': offsetX,
      'offsetY': offsetY,
      'selectedEdge': selectedEdge,
      'snr': snr,
      'NoiseLevel': noiseLevel,
      'txPower': txPower,
      'routerX': routerX,
      'routerY': routerY,
      'roomArea': roomArea,
    };
  }
}
