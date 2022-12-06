import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/model/address_book_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// 通讯录页面
class AddressBook extends StatefulWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddressBookState();

}

class _AddressBookState extends State<AddressBook> {

  int activeIndex = 0;
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      data = AddressBookModel.getAddressBookModelData();
    });
    // 滚动监听
    itemPositionsListener.itemPositions.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: '通讯录'),
      body: Stack(
        children: [
          /// 滚动列表
          ScrollablePositionedList.builder(
              shrinkWrap: true,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: data.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                      height: 50.w,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 40.w),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(245, 245, 245, 1)
                      ),
                      child: Text(data[index]["group"]),
                    ),
                    Column(
                      children: data[index]["children"].map<Widget>((abm) {
                        return CommonWidget.listTileByUrl(title: abm.name??'', leadingUrl: abm.avatar, desc: abm.phone, hasDefault: true,callBack: (){
                          Get.toNamed("/address_book_detail", arguments: abm.name);
                        });
                      }).toList(),
                    ),
                  ],
                )
              ),
          ),
          Positioned(
              right: 20.w,
              bottom: 40.w,
              top: 40.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.asMap().entries.map<Widget>((e) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        activeIndex = e.key;
                      });
                      //跳到哪个index  并以什么动画执行
                      itemScrollController.scrollTo(
                          index: e.key,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn
                      );
                    },
                    child: Container(
                      width: 40.w,
                      padding: EdgeInsets.only(bottom: 10.w),
                      child: Text(
                        "${e.value['group']}",
                        style: TextStyle(color: activeIndex == e.key ? Colors.green : Colors.black, fontSize: 22.sp),
                      ),
                    ),
                  );
                }).toList(),
              )
          )
        ],
      ),
    );
  }

}
