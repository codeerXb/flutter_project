import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/screen_adapter.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({super.key});

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {

  Widget setupTopView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: ScreenAdapter.height(150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenAdapter.radius(18.0))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  
                },
                child: ListTile(
                leading: Text("User",style: TextStyle(fontSize: ScreenAdapter.fontSize(30),fontWeight: FontWeight.bold),),
                trailing: Icon(Icons.arrow_back_ios_outlined,size: ScreenAdapter.fontSize(15),),
              ),
              ),
              Text("data",style: TextStyle(fontSize: ScreenAdapter.fontSize(14),fontWeight: FontWeight.normal),),
              Text("data",style: TextStyle(fontSize: ScreenAdapter.fontSize(14),fontWeight: FontWeight.normal),),
            ],
          ),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55.0)
            ),
            child: Image.asset("",fit: BoxFit.cover,),
          )
        ],
      ),
    );
  }

  Widget settingPanel() {
    return InfoBox(
      boxCotainer: Column(
        children: [
          InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("Device lnfo",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("Maintenance",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("Router Upgrade",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("About",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ),
            InkWell(
              onTap: () {
                
              },
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              leading: Image.asset(""),
              title: const Text("Service",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ),
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        ColorUtils.hexToColor("#2B7AFB"),
        ColorUtils.hexToColor("#FFFFFF"),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: SafeArea(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 90)),
          setupTopView(context),
          settingPanel()
        ],),
      )),
    );
  }
}