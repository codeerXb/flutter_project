import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/cache_util.dart';
import 'package:flutter_template/core/utils/common_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 清除缓存
class ClearCache extends StatefulWidget {
  const ClearCache({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClearCacheState();
}

class _ClearCacheState extends State<ClearCache> {
  String cacheSizeStr = "";

  @override
  void initState() {
    super.initState();
    CacheUtils.loadApplicationCache().then((value) => {
          setState(() {
            cacheSizeStr = CommonUtil.formatSize(value);
          }),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '清除缓存'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 清除缓存
              CommonWidget.simpleWidgetWithUserDetail("清除缓存",
                  value: cacheSizeStr),

              /// 清除缓存按钮
              CommonWidget.buttonWidget(
                  title: '清除缓存',
                  callBack: () {
                    CacheUtils.clearApplicationCache();
                    ToastUtils.success("缓存已清空");
                    Get.back();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
