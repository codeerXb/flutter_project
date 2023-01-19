import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';

///查看大图使用
class SwiperPage extends StatefulWidget {
  const SwiperPage({Key? key}) : super(key: key);

  @override
  State<SwiperPage> createState() => _SwiperPageState();
}

class _SwiperPageState extends State<SwiperPage> {
  List<Map> imgList = [
    // {"url": "https://pic2.zhimg.com/v2-848ed6d4e1c845b128d2ec719a39b275_b.jpg"},
    // {
    //   "url":
    //       "https://pic2.zhimg.com/80/v2-40c024ce464642fcab3bbf1b0a233174_hd.jpg"
    // },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      imgList = Get.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black87,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (() {
          //点击任意地方都能关闭页面，并且不影响你的滑动查看
          Navigator.pop(context);
        }),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
                width: double.infinity,
                child: Image.network(
                  imgList[index]["url"],
                  fit: BoxFit.contain,
                ));
          },
          itemCount: imgList.length,
          pagination: const SwiperPagination(), //下面的分页小点
//        control: new SwiperControl(),  //左右的那个箭头,在某模拟器中会出现蓝线
        ),
      ),
    );
  }
}
