import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ConnectionlessPage extends StatelessWidget {
  const ConnectionlessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network fault",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Text('Make sure the router is connected to power and plug in a network cable to the WAN port'),
            Image.asset("assets/images/sureWan.png",
                fit: BoxFit.fitWidth, height: 600.w, width: 600.w),
          ],
        ),
      ),
    );
  }
}
