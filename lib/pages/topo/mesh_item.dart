import 'package:flutter/material.dart';
import 'package:css_filter/css_filter.dart';

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
                height: 64,
                width: 64,
                margin: const EdgeInsets.all(5),
                child: Image.network(
                    'https://img.redocn.com/sheying/20200324/shujiashangdeshuji_10870699.jpg',
                    fit: BoxFit.cover),
              ),
            ),
            if (isNative)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 168, 168, 168),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  height: 16,
                  width: 30,
                  padding: const EdgeInsets.only(left: 2),
                  child: const Text(
                    '本机',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
          ],
        ),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Text('datdadada'),
      ],
    );
  }
}
