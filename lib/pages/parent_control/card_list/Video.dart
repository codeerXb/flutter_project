import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Video Streaming'),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: const SingleChildScrollView(
            // Image.asset('assets/images/parentalControl/Video.jpg')
            child: Image(
              image: AssetImage('assets/images/parental_control-video.jpg'),
            ),
          ),
        ));
  }
}
