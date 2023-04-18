import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:get/get.dart';

import '../../core/widget/common_box.dart';
import '../../generated/l10n.dart';
import '../toolbar/toolbar_controller.dart';

class LanguageChange extends StatefulWidget {
  const LanguageChange({super.key});

  @override
  State<LanguageChange> createState() => _LanguageChangeState();
}

class _LanguageChangeState extends State<LanguageChange> {
  var color = Colors.blue[800];
  final ToolbarController toolbarController = Get.put(ToolbarController());
  String localeModel = 'null';
  @override
  initState() {
    //读取当前语言
    sharedGetData('lang', String).then(((res) {
      setState(() {
        localeModel = res.toString();
      });
      debugPrint('init lang${res.toString()}');
    }));
    super.initState();
  }

  //构建语言选择项
  Widget _buildLanguageItem(String lan, value) {
    return ListTile(
      title: Text(
        lan,
        // 对APP当前语言进行高亮显示
        style: TextStyle(color: localeModel == value ? color : null),
      ),
      trailing: localeModel == value ? Icon(Icons.done, color: color) : null,
      onTap: () {
        setState(() {
          localeModel = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          S.of(context).language,
          style: const TextStyle(color: Colors.black),
        ),
        // elevation: 0,
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
            ),
            child: Text(S.current.confirm),
            onPressed: () {
              // handle the press
              sharedAddAndUpdate('lang', String, localeModel);
              if (localeModel != 'null') {
                List<String> lang = localeModel.split('_');
                S.load(Locale(lang[0], lang[1]));
              } else {
                S.load(const Locale('null'));
              }
              Get.offAllNamed("/home");
              toolbarController.setPageIndex(0);
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: ListView(
            children: <Widget>[
              _buildLanguageItem(S.current.autoLang, 'null'),
              _buildLanguageItem("中文简体", "zh_CN"),
              _buildLanguageItem("English", "en_US"),
            ],
          ),
        ),
      ),
    );
  }
}
