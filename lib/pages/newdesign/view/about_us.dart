import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/screen_adapter.dart';

class AboutUsPageView extends StatelessWidget {
  const AboutUsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: "About",
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
        child: Container(
          color: ColorUtils.hexToColor("#F3F4F6"),
          child: Column(
            children: [
              Container(
                height: ScreenAdapter.height(210),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18.0)),
                child: Text(
                  "",
                  style: TextStyle(fontSize: 14),
                  softWrap: true,
                ),
              ),
              InfoBox(
                  boxCotainer: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: Text(
                        "Support",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: Text(
                        "Website",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              )),
              const Spacer(),

              Text(
                    "Version",
                    style: TextStyle(
                        fontSize: 14, color: ColorUtils.hexToColor("#999999")),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
