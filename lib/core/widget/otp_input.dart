import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 55,
      child: Center(
        child: TextField(
          autofocus: autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 3,
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(5),
              counterText: '',
              hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
          onChanged: (value) {
            if (value.length == 3) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}

// 禁用
class DisInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const DisInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 55,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 3,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            counterText: '',
            enabled: false,
            filled: true, //一定加入个属性不然不生效
            fillColor: Color.fromARGB(255, 243, 240, 240),
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
