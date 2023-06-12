import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

class TestEdit extends StatefulWidget {
  const TestEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestEditState();
}

class _TestEditState extends State<TestEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            customAppbar(context: context, title: S.current.DetectionAndEdit),
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
                child: Text(
                  S.current.EditUnit,
                  style: const TextStyle(
                    color: Colors.blue, // 将文字颜色设置为蓝色
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('     low  '),
                Container(
                  height: 10.w,
                  width: 150.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(249, 245, 6, 6),
                        Color.fromARGB(235, 118, 240, 4)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text('  Strong'),
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 20.w)),
            Center(
              child: Text(S.current.Blueprint),
            ),
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
              onPressed: () {},
              child: Text(S.current.RetestF),
            ),
          ],
        ),
      ),
    );
  }
}
