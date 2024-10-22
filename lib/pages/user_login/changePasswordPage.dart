import 'package:flutter/material.dart';
import 'package:time_picker_sheet_fork/widget/sheet.dart';
import 'package:time_picker_sheet_fork/widget/time_picker.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  DateTime dateTimeSelected = DateTime.now();

  void _openTimePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Please set time',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        minuteTitleStyle: const TextStyle(color: Colors.black,fontSize: 16),
        hourTitleStyle: const TextStyle(color: Colors.black,fontSize: 16),
        sheetCloseIconColor: Colors.black,
        saveButtonWidget: const Text('Save', style: TextStyle(color: Colors.white)),
      ),// 'Save'
    );

    if (result != null) {
      setState(() {
        dateTimeSelected = result;
      });
      debugPrint("${dateTimeSelected.hour},${dateTimeSelected.minute}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _openTimePickerSheet(context),
              child: Text('show time picker sheet'),
            ),
            Text('Time ${dateTimeSelected.hour}:${dateTimeSelected.minute}'),
          ],
        ),
      ),
    );
  }
}
