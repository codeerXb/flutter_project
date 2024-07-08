import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/widget/custom_app_bar.dart';

class WIFIManager extends StatelessWidget {
  const WIFIManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title:"Account",
      ),
      body: InfoBox(
        boxCotainer: Column(
          children: [
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Profile",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Change Password",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Unbind Device",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading:Text("Logout",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),), 
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: Text("Delete Account",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),), 
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            )
        ],)
        ),
    );
  }
}