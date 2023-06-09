import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';

class TestEdit extends StatefulWidget {
  const TestEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestEditState();
}

class _TestEditState extends State<TestEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Detection and editing'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.only(top: 20.w)),

            Image.asset(
              'assets/images/signalcover.jpg',
            ),

            Padding(padding: EdgeInsets.only(top: 20.w)),

            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed("/signal_cover");
                },
                child: const Text(
                  'Edit unit',
                  style: TextStyle(
                    color: Colors.blue, // 将文字颜色设置为蓝色
                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 20.w)),

            const Center(
              child: Text(
                'Wi-Fi Signal Country Blueprint (for reference only)',
              ),
            ),
            // const Center(
            //   child: Text(
            //     'Press and drag to move the routing circle to the appropriate location in the room',
            //   ),
            // ),

            Padding(padding: EdgeInsets.only(top: 20.w)),
            //按钮
            const BottomButton(),
          ],
        ));
  }
}

//底部按钮
class BottomButton extends StatefulWidget {
  const BottomButton({super.key});
  @override
  State<StatefulWidget> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Retest 1F'),
            ),
          ],
        ),
      ),
    );
  }
}
