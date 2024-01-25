import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ParentConfigHomePage extends StatefulWidget {
  const ParentConfigHomePage({super.key});

  @override
  State<ParentConfigHomePage> createState() => _ParentConfigHomePageState();
}

class _ParentConfigHomePageState extends State<ParentConfigHomePage> {
  bool switchState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parental control",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              icon:const Icon(
                Icons.add_circle,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                Get.toNamed("/parentConfigPage");
              },
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return setUpCardView(context,"Config123444",true);
          }),
    );
  }

  Widget setUpCardView(BuildContext context,String name,bool ischecked) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      // height: 100,
      padding:const EdgeInsets.only(top: 15,left: 15,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: InkWell(
            onTap: () {},
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 15,right: 15),
                child: Row(
                  children: [
                    Image.asset("assets/images/config_parent.png",width: 30,height: 30,),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style:const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(width: 5,),
          SizedBox(
            width: 70,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlutterSwitch(
                      width: 70.0,
                      // height: 55.0,
                      showOnOff: true,
                      activeColor: Colors.green,
                      activeTextColor: Colors.white,
                      inactiveTextColor: Colors.blue[50]!,
                      value: switchState,
                      onToggle: (val) {
                        setState(() {
                          switchState = val;
                        });
                      },
                    ),
                // SizedBox(
                //   width: 40,
                //   height: 30,
                //   child: CupertinoSwitch(
                //     value: switchState,
                //     onChanged: (value) {
                //       setState(() {
                //         switchState = value;
                //       });
                //     },
                //     thumbColor: CupertinoColors.white,
                //     activeColor: CupertinoColors.activeGreen,
                //   ),
                // ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.lightGreen, width: 0.5), // 边色与边宽度
                    color: Colors.white, // 底色
                    //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // color: Colors.green,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/images/delete1.png",width: 25,height: 25,),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
