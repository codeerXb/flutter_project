import 'package:flutter/material.dart';

class DatePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DatePickerPage();
  }
}

class _DatePickerPage extends State<DatePickerPage> {
  var _time = TimeOfDay.now();

  _showTimePicker() async {
    //系统自带的时间dialog
    var time = await showTimePicker(context: context, initialTime: _time);
    setState(() {
      if (time != null) {
        _time = time;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          //没有样式，带有点击时水波纹的效果
          onTap: _showTimePicker,
          //没有样式，带有点击时水波纹的效果
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_time'), //选中后将其数据回调给Text
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        )
      ],
    ));
  }
}
