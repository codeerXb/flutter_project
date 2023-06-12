import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 以太网
class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  TextEditingController questionController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    questionController.dispose();
    contactController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.current.Ethernet),
      body: InkWell(
        onTap: () => closeKeyboard(context),
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                // color: Color.fromRGBO(240, 240, 240, 1)
                color: Colors.white),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 问题和意见
                  questionsCommentsWidget(),

                  /// 联系方式
                  contactInformationWidget(),

                  /// 提交按钮
                  CommonWidget.buttonWidget(callBack: () {
                    if ((_formKey.currentState as FormState).validate()) {
                      onSubmit(context);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 问题和意见
  Widget questionsCommentsWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20.w, left: 40.w, right: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "问题和意见",
            style: TextStyle(
                color: const Color.fromRGBO(48, 49, 51, 1), fontSize: 26.sp),
          ),
          TextField(
            controller: questionController,
            maxLines: 5,
            maxLength: 500,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 20.w, 0, 0),
              border: InputBorder.none,
              hintText: "请输入10个字以上的问题描述以便我们提供更好的帮助",
              hintStyle: TextStyle(
                  color: const Color.fromRGBO(150, 150, 150, 1),
                  fontSize: 24.sp),
            ),
            style: TextStyle(
                color: const Color.fromRGBO(48, 49, 51, 1), fontSize: 26.sp),
            inputFormatters: [LengthLimitingTextInputFormatter(500)],
          ),
          CommonWidget.dividerWidget(),
        ],
      ),
    );
  }

  /// 联系方式
  Widget contactInformationWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20.w, left: 40.w, right: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "联系方式（手机、邮箱、QQ号码）",
            style: TextStyle(
                color: const Color.fromRGBO(48, 49, 51, 1), fontSize: 26.sp),
          ),
          TextField(
            controller: contactController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "选填，便于我们与你联系，进一步沟通",
              hintStyle: TextStyle(
                  color: const Color.fromRGBO(150, 150, 150, 1),
                  fontSize: 24.sp),
              isDense: true,
              border: InputBorder.none,
            ),
            style: TextStyle(
                color: const Color.fromRGBO(48, 49, 51, 1), fontSize: 26.sp),
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
          ),
          CommonWidget.dividerWidget(),
        ],
      ),
    );
  }

  /// 提交方法
  void onSubmit(BuildContext context) {
    closeKeyboard(context);
    String questionText = questionController.text;
    if (questionText.trim().length < 10 || questionText.trim().length > 500) {
      return ToastUtils.toast("问题和意见在10 到500 个字符之间");
    }

    /// 这里需要提交到后台
    print(
        "questionText: $questionText, contactText: ${contactController.text}");
    ToastUtils.success("提交成功");
    Get.back();
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
}
