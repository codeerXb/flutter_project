import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constant.dart';
import '../../core/widget/nk_swiper_pagination.dart';

///网络拓扑
class Topo extends StatefulWidget {
  const Topo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopoState();
}

class _TopoState extends State<Topo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: '网路拓扑'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: Constant.paddingLeftRight,
              right: Constant.paddingLeftRight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ),
      ),
    );
  }
}
