import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CommonPicker {
  static Future<int?>? showPicker({
    BuildContext? context,
    List<String>? options,
    int? value = 0,
    double height = 300,
  }) {
    var controller = FixedExtentScrollController(initialItem: value!);

    return showCupertinoModalPopup(
      context: context!,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[200],
          height: height,
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(controller.selectedItem);
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: controller,
                  // 使用 scaffold 的背景色
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  itemExtent: 32,
                  onSelectedItemChanged: (val) {},
                  children: options!.map((item) => Text(item)).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
