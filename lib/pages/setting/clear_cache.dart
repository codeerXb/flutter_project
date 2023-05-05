import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/cache_util.dart';
import 'package:flutter_template/core/utils/common_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:get/get.dart';
import '../../core/widget/common_box.dart';
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

  bool _isLoading = false;
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    CacheUtils.clearApplicationCache();
    ToastUtils.success(S.current.CacheCleared);
    Get.back();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: S.current.clearCache,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.w),
              child: OutlinedButton(
                onPressed: _isLoading ? null : _saveData,
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    if (!_isLoading)
                      Text(
                        S.of(context).clear,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _isLoading ? Colors.grey : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 清除缓存
              TitleWidger(title: S.current.clearCache),
              InfoBox(
                  boxCotainer: Column(
                children: [
                  //value: cacheSizeStr
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: S.of(context).clearCache,
                    righText: cacheSizeStr,
                  )),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
