import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'arc_progress_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    Key? key,
    required double progress2,
    required this.progress,
    required this.pressUp,
    required this.pressDown,
  })  : _progress = progress2,
        super(key: key);

  final double _progress;
  final int progress;
  final void Function() pressUp;
  final void Function() pressDown;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        children: [
          ArcProgresssBar(progress: _progress),
          Positioned(
              top: 0.22.sh,
              right: 0.37.sw,
              width: 200.sp,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$progress',
                          style: TextStyle(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.sp,
                          )),
                      Text(
                        'MB',
                        style: TextStyle(
                          fontSize: 28.sp,
                          height: 2.sp,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        Icons.circle,
                        color: const Color(0xff86e3ce),
                        size: 32.sp,
                      ),
                      Text(
                        '已用流量',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            height: 3.1.sp,
                            color: Colors.grey),
                      )
                    ],
                  )
                ],
              )),
          Positioned(
            top: 0.1.sh,
            left: 0.sw,
            child: TextButton(onPressed: pressUp, child: const Text('增加')),
          ),
          Positioned(
            top: 0.2.sh,
            left: 0.sw,
            child: TextButton(
                onPressed: pressDown,
                child: Text('减少', style: TextStyle(fontSize: 30.sp))),
          )
        ],
      ),
      Center(
        child: Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: const BoxDecoration(
              // 背景色
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                UploadSpeed(),
                DownloadSpeed(),
                OnlineCount(),
              ],
            )),
      )
    ]);
  }
}

class OnlineCount extends StatelessWidget {
  const OnlineCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '0',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              '台',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('实时在线'),
          ],
        ),
      ],
    );
  }
}

class DownloadSpeed extends StatelessWidget {
  const DownloadSpeed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '1.0',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              'KB/s',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('下行速度'),
          ],
        ),
      ],
    );
  }
}

class UploadSpeed extends StatelessWidget {
  const UploadSpeed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '1.0',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              'KB/s',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('上行速度'),
          ],
        ),
      ],
    );
  }
}
