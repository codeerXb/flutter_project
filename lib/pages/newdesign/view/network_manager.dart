import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/widget/custom_app_bar.dart';

class WIFIManager extends StatelessWidget {
  const WIFIManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title:"Network Settings",
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
              title: const Text("WAN Status",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("WAN Settings ",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("DNS Settings",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("LAN Settings",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            )
        ],)
        ),
    );
  }
}