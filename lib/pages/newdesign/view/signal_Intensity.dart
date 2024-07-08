import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import '../../../core/utils/color_utils.dart';

class SignalIntensityPageView extends StatefulWidget {
  const SignalIntensityPageView({super.key});

  @override
  State<SignalIntensityPageView> createState() =>
      _SignalIntensityPageViewState();
}

class _SignalIntensityPageViewState extends State<SignalIntensityPageView> {
  int selectIndex = 1;
  var imageName = "";
  var images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: "Signal Intensity "),
      body: Container(
        decoration: BoxDecoration(color: ColorUtils.hexToColor("#F3F4F6")),
        child: Column(
          children: [
            Image.asset(
              imageName,
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "",
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w,left: 20.w,right: 20.w),
              child: Container(
                height: 110.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.r)
              ),
              child: RadioListTile(
              key: const ValueKey(1),
                value: 1,
                groupValue: selectIndex,
                activeColor: ColorUtils.hexToColor("#2B7AFB"),
                title: Text("Sleep Mode",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),),
                subtitle: Text("Weakening WiFi signals For greater energy efficiency",softWrap: true,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400),),
                onChanged: (value) { 
                  setState(() {
                    selectIndex = int.parse(value.toString());
                    imageName = images[0];
                  });
                  },
                controlAffinity: ListTileControlAffinity.trailing
                ),
            ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w,left: 20.w,right: 20.w),
              child: Container(
                height: 110.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.r)
              ),
              child: RadioListTile(
              key: const ValueKey(2),
                value: 2,
                groupValue: selectIndex,
                activeColor: ColorUtils.hexToColor("#2B7AFB"),
                title: Text("Pattern",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),),
                subtitle: Text("WiFi coverage is average Recommended to use through wall mode",softWrap: true,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400),),
                onChanged: (value) { 
                  setState(() {
                    selectIndex = int.parse(value.toString());
                    imageName = images[1];
                  });
                  },
                controlAffinity: ListTileControlAffinity.trailing
                ),
            ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w,left: 20.w,right: 20.w),
              child: Container(
                height: 110.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.r)
              ),
              child: RadioListTile(
              key: const ValueKey(3),
                value: 3,
                groupValue: selectIndex,
                activeColor: ColorUtils.hexToColor("#2B7AFB"),
                title: Text("Through Wall Mode",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),),
                subtitle: Text("Enhance WiFi signal Enhance WiFi wall penetration capability",softWrap: true,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400),),
                onChanged: (value) { 
                  setState(() {
                    selectIndex = int.parse(value.toString());
                    imageName = images[2];
                  });
                  },
                controlAffinity: ListTileControlAffinity.trailing
                ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
