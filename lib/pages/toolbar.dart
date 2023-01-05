import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/app_update_util.dart';
import 'package:flutter_template/pages/address_book/index.dart';
import 'package:flutter_template/pages/net_status/index.dart';
import 'package:flutter_template/pages/setting/index.dart';
import 'package:flutter_template/pages/topo/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../core/utils/sign_out_util.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  final PageController _pageController = PageController();
  String vn = Get.arguments['vn'];

  /// 底部导航
  static const List<BottomNavigationBarItem> menuList = [
    BottomNavigationBarItem(
      icon:
          Image(image: AssetImage('assets/images/icon_homepage_no_state.png')),
      activeIcon:
          Image(image: AssetImage('assets/images/icon_homepage_state.png')),
      label: '状态',
    ),
    BottomNavigationBarItem(
      icon: Image(image: AssetImage('assets/images/icon_homepage_no_topo.png')),
      activeIcon:
          Image(image: AssetImage('assets/images/icon_homepage_topo.png')),
      label: '网络拓扑',
    ),
    BottomNavigationBarItem(
      icon:
          Image(image: AssetImage('assets/images/icon_homepage_no_route.png')),
      activeIcon:
          Image(image: AssetImage('assets/images/icon_homepage_route.png')),
      label: '高级设置',
    ),
  ];

  /// 对应页面
  List<Widget> getPages() {
    List<Widget> pages = [
      NetStatus(vn),
      const Topo(),
      const Setting(),
    ];
    return pages;
  }

  @override
  void initState() {
    ///登录是app更新检查
    // if (false) {
    //   /// 这里先注释掉
    //   AppUpdateUtils().updateApp();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('vn=$vn');
    return WillPopScope(
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: getPages(),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: const Color.fromRGBO(95, 141, 255, 1),
              unselectedItemColor: const Color.fromRGBO(76, 76, 76, 1),
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _pageController.jumpToPage(index);
                  currentIndex = index;
                });
              },
              items: menuList),
        ),
        onWillPop: () async =>
            SignOutAppUtil.exitBy2Click(status: _scaffoldKey.currentState));
  }
}
