import 'package:flutter/material.dart';

class MyIndexApp extends StatefulWidget {
  const MyIndexApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyIndexAppState();
}

class _MyIndexAppState extends State<MyIndexApp> {
  List<RectData> _rects = [];
  String _currentRectName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画布'),
      ),
      body: SizedBox(
        height: 400,
        width: double.infinity,
        child: InteractiveViewer(
          minScale: 0.1, // 最小缩放比例
          maxScale: 4.0, // 最大缩放比例
          constrained: false, // 是否对缩放和平移进行限制
          child: GestureDetector(
            onTapDown: (details) {
              const rectSize = Size(50, 50); // 矩形大小
              final tappedPosition = details.localPosition;

              // 将点击位置转换为网格位置
              final gridPosition = Offset(
                tappedPosition.dx - (tappedPosition.dx % rectSize.width),
                tappedPosition.dy - (tappedPosition.dy % rectSize.height),
              );

              // 创建一个带名称的矩形数据
              final newRect = RectData(
                rect: Rect.fromLTWH(
                  gridPosition.dx,
                  gridPosition.dy,
                  rectSize.width,
                  rectSize.height,
                ),
                name: _currentRectName,
              );

              setState(() {
                _rects.add(newRect);
              });
            },
            child: CustomPaint(
              painter: GridPainter(),
              foregroundPainter: RectsPainter(_rects),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('为矩形命名'),
                content: TextField(
                  onChanged: (value) {
                    setState(() {
                      _currentRectName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: '请输入矩形名称',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _rects.add(
                          RectData(
                            rect: Rect.zero,
                            name: _currentRectName,
                          ),
                        );
                        _currentRectName = '';
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Paint _gridPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    const double cellSize = 50; // 网格单元大小

    // 绘制垂直网格线
    for (double x = 0; x <= size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _gridPaint);
    }

    // 绘制水平网格线
    for (double y = 0; y <= size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RectsPainter extends CustomPainter {
  final List<RectData> rects;

  RectsPainter(this.rects);

  @override
  void paint(Canvas canvas, Size size) {
    for (final rectData in rects) {
      final rect = rectData.rect;
      final paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 5
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
        Offset(rect.left + 5, rect.top + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RectData {
  final Rect rect;
  final String name;

  RectData({required this.rect, required this.name});
}
