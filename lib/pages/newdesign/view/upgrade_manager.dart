import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import '../../../core/utils/color_utils.dart';
import 'package:grouped_scroll_view/grouped_scroll_view.dart';
import '../model/upgrade_device_bean.dart';

class UpgradeManagerPageView extends StatefulWidget {
  const UpgradeManagerPageView({super.key});

  @override
  State<UpgradeManagerPageView> createState() => _UpgradeManagerPageViewState();
}

class _UpgradeManagerPageViewState extends State<UpgradeManagerPageView> {
  var upgradeTips = "";

  List<UpgradeDeviceBean> datas = [];

  Widget upgradeDeviceListView() {
    return GroupedScrollView.list(
      groupedOptions: GroupedScrollViewOptions(
          itemGrouper: (UpgradeDeviceBean bean) {
            return bean.birthYear;
          },
          stickyHeaderBuilder:
              (BuildContext context, int year, int groupedIndex) => Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints.tightFor(height: 30),
                    child: Text(
                      '$year',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
      itemBuilder: (BuildContext context, UpgradeDeviceBean item) {
        return Container(
          constraints: const BoxConstraints.expand(height: 35),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints.expand(height: 30),
                color: Colors.lightGreen,
                child: Center(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      data: datas,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: customAppbar(title: "Upgrade Management"),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(""),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  upgradeTips,
                  style: TextStyle(
                      fontSize: 14, color: ColorUtils.hexToColor("#999999")),
                )
              ],
            ),
            upgradeDeviceListView(),
            Positioned(
                bottom: 50,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 190,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorUtils.hexToColor("#2B7AFB"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Check Updates",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )),
                ))
          ],
        ),
      ),
    ));
  }
}
