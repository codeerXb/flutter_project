import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/widget/custom_app_bar.dart';

class WIFIManager extends StatelessWidget {
  const WIFIManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title:"WiFi Manage",
      ),
      body: InfoBox(
        boxCotainer: Column(
          children: [
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("WiFi Settings",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("Signal Intensity ",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("WiFi Quality",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("WPS",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            )
        ],)
        ),
    );
  }
}