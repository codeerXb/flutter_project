import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 家长控制
class Parcontrol extends StatefulWidget {
  const Parcontrol({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParcontrolState();
}

class _ParcontrolState extends State<Parcontrol> {
  int index = 0;
  //开始时间
  var startDate = DateTime.now().toString().split(' ')[0];
  String type = '暂未订阅';
  bool istrue = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //读取存储的订阅选项
    sharedGetData('parental_control', int).then(((res) {
      if (res != null) {
        setState(() {
          istrue = true;
          index = int.parse(res.toString());
          switch (index) {
            case 1:
              type = '连续包年';
              break;
            case 2:
              type = '连续包季';
              break;
            case 3:
              type = '连续包月';
              break;
          }
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context, title: S.of(context).parentalControl),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //你的订阅
                TitleWidger(title: S.of(context).yourServiece),
                Card(
                  elevation: 5, //设置卡片阴影的深度
                  shape: const RoundedRectangleBorder(
                    //设置卡片圆角
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(
                      left: 26.w, right: 26.w, bottom: 26.w), //设置卡片外边距
                  child: Column(
                    children: [
                      //您的订阅卡片
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            "https://img1.baidu.com/it/u=3844424264,2786123313&fm=253&fmt=auto&app=138&f=JPEG?w=256&h=256",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: !istrue
                            ? Text('订阅解锁服务')
                            : Text('开始时间:$startDate'),
                        subtitle: Text("套餐类型:$type"),
                        // trailing: Text("剩余1个月"),
                      ),
                    ],
                  ),
                ),
                if (!istrue)
                  //选项
                  TitleWidger(title: S.of(context).options),
                if (!istrue)
                  Card(
                    elevation: 5, //设置卡片阴影的深度
                    shape: const RoundedRectangleBorder(
                      //设置卡片圆角
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                        left: 26.w, right: 26.w, bottom: 26.w), //设置卡片外边距
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('连续包年 ￥148 已优惠￥90'),
                          trailing: Icon(
                            Icons.check,
                            color: index == 1 ? Colors.black : Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                        ),
                        commonLine(),
                        ListTile(
                          title: Text('连续包季 ￥40 折合13.3/月'),
                          trailing: Icon(
                            Icons.check,
                            color: index == 2 ? Colors.black : Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                        ),
                        commonLine(),
                        ListTile(
                          title: Text('连续包月 ￥15'),
                          trailing: Icon(
                            Icons.check,
                            color: index == 3 ? Colors.black : Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              index = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                //提交
                if (!istrue)
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Center(
                      child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {
                            if (index == 0) return;
                            sharedAddAndUpdate('parental_control', int, index);
                            ToastUtils.toast('订阅成功');
                            Get.toNamed("/sub_service");
                            istrue = true;
                          },
                          child: Text(
                            "确定协议并支付",
                            style: TextStyle(fontSize: 30.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!istrue)
                  //阅读协议
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Center(
                      child: SizedBox(
                          height: 70.sp,
                          width: 680.sp,
                          child: TextButton(
                              onPressed: () {
                                print(1);
                              },
                              child: Text('开始前阅读《服务协议》和《自动续费协议》'))),
                    ),
                  ),
                if (istrue)
                  //取消订阅
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Center(
                      child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 212, 40, 34))),
                          onPressed: () {
                            sharedDeleteData('parental_control');
                            istrue = false;
                            ToastUtils.toast('取消订阅成功');
                            Get.toNamed("/sub_service");
                          },
                          child: Text(
                            "取消订阅",
                            style: TextStyle(fontSize: 30.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
