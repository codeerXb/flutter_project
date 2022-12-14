import 'package:flutter/material.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MESHItem extends StatelessWidget {
  final String title;
  final bool isShow;
  final bool isNative;
  const MESHItem({
    Key? key,
    required this.title,
    required this.isShow,
    required this.isNative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CSSFilter.apply(
              value: CSSFilterMatrix().opacity(!isShow ? 0.3 : 1),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                clipBehavior: Clip.hardEdge,
                height: 120.h,
                width: 120.h,
                margin: const EdgeInsets.all(5),
                child: Image.network(
                    'https://img.redocn.com/sheying/20200324/shujiashangdeshuji_10870699.jpg',
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            title,
            style: TextStyle(fontSize: 24.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Text('datdadada'),
      ],
    );
  }
}
