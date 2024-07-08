import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/widget/custom_app_bar.dart';

class MaintenancePageView extends StatelessWidget {
  const MaintenancePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title:"Maintenance",
      ),
      body: InfoBox(
        boxCotainer: Column(
          children: [
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Schedule Reboot",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Reboot",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Factroy Reset",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            )
        ],)
        ),
    );
  }
}