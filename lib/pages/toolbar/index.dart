import 'package:flutter/material.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/setting/index.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter_template/pages/topo/index.dart';
import 'package:get/get.dart';

import '../../core/utils/sign_out_util.dart';
import '../net_status/index.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  final PageController _pageController = PageController();
  // String vn = Get.arguments['vn'];
  final ToolbarController toolbarController = Get.put(ToolbarController());

  /// 对应页面
  List<Widget> getPages() {
    List<Widget> pages = [
      const NetStatus(),
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
    // debugPrint('vn=$vn');
    return WillPopScope(
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: getPages(),
          ),
          bottomNavigationBar: Obx(() {
            if (toolbarController.pageIndex.value != 0) {
              _pageController.jumpToPage(toolbarController.pageIndex.value);
            }
            return BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: const Color.fromRGBO(95, 141, 255, 1),
                unselectedItemColor: const Color.fromRGBO(76, 76, 76, 1),
                currentIndex: toolbarController.pageIndex.value,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  toolbarController.setPageIndex(index);
                  _pageController.jumpToPage(index);
                },

                /// 底部导航
                items: [
                  BottomNavigationBarItem(
                    icon: const Image(
                        image: AssetImage(
                            'assets/images/icon_homepage_no_state.png')),
                    activeIcon: const Image(
                        image: AssetImage(
                            'assets/images/icon_homepage_state.png')),
                    label: S.of(context).state,
                  ),
                  BottomNavigationBarItem(
                    icon: const Image(
                        image: AssetImage(
                            'assets/images/icon_homepage_no_topo.png')),
                    activeIcon: const Image(
                        image:
                            AssetImage('assets/images/icon_homepage_topo.png')),
                    label: S.of(context).netTopo,
                  ),
                  BottomNavigationBarItem(
                    icon: const Image(
                        image: AssetImage(
                            'assets/images/icon_homepage_no_route.png')),
                    activeIcon: const Image(
                        image: AssetImage(
                            'assets/images/icon_homepage_route.png')),
                    label: S.of(context).advancedSet,
                  ),
                ]);
          }),
        ),
        onWillPop: () async =>
            SignOutAppUtil.exitBy2Click(status: _scaffoldKey.currentState));
  }
}
