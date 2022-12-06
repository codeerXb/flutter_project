import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/constant.dart';
import 'package:flutter_template/core/utils/string_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用Widget
class CommonWidget {

  /// 底部border
  /// @param {Color} color
  /// @param {bool} show  是否显示底部border
  static Border borderBottom({ Color? color, bool show = true}) {
    return Border(
        bottom: BorderSide(
            color: (color == null || !show)
                ? (show ? const Color.fromRGBO(242, 242, 242, 1) : Colors.transparent)
                : color,
            width: 1));
  }

  /// 搜索框
  /// @param {double} width
  /// @param {double} height
  /// @param {String} hintText
  /// @param {Function} callBack
  static Widget searchWidget({double? width, double? height, String hintText = "请输入关键字", bool showSuffixIcon = false, required Function callBack}){
    width ??= Constant.defaultWidth;
    height ??= 80.w;
    TextEditingController searchController = TextEditingController();
    return Container(
      width: width,
      height: height,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 10.w, left: Constant.paddingLeftRight, right: Constant.paddingLeftRight,bottom: 10.w),
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            width: width - 150.w,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: Constant.searchDecorationColor
            ),
            padding: EdgeInsets.only(left: 10.w),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: searchController,
              style: Constant.searchTextFiledStyle,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: -25.w, right: showSuffixIcon ? -20.0.w : 20.w),
                /// 左边图标
                icon: const Icon(Icons.search, color: Color(0xff979DA3),),
                /// 右边图标
                suffixIcon: showSuffixIcon ? InkWell(
                  onTap: (){
                    searchController.text = "";
                  },
                  child: Icon(Icons.close, color: const Color(0xff979DA3), size: 30.w,),
                ) : null,
                hintText: hintText,
                hintStyle: Constant.searchTextFieldHintStyle,
                isDense : true,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.w),
            child: InkWell(
              onTap: () => callBack(searchController.text),
              child: const Text('搜索', style: TextStyle(color: Color(0xff051220)),),
            )
          )
        ],
      ),
    );
  }

  /// 分割线
  /// dividerHeight 默认1.w
  /// dividerColor 默认 0xffeeeff2
  static Widget dividerWidget({double? dividerHeight, int dividerColor = 0xfff0f0f0}){
    dividerHeight ??= 1.w;
    return Divider(height: dividerHeight,color: Color(dividerColor),);
  }

  /// 列表显示 - 消息
  /// @param {Widget} leading 左侧的图标
  /// @param {Color} leadingBackgroundColor 图标的背景颜色
  /// @param {String} title 上面的文字
  /// @param {String} desc 下面的描述
  /// @param {String} trailingTitle 右侧显示
  /// @param {Function} onclick 点击回调函数
  static Widget listTile({Widget? leading, Color leadingBackgroundColor = const Color.fromRGBO(88, 202, 147, 1), String? tipNum,
    required String title, String? desc, String? trailingTitle, Function? callBack}){
    return InkWell(
      splashColor: Colors.transparent, // 溅墨色（波纹色）
      highlightColor: Colors.transparent, // 点击时的背景色（高亮色）
      onTap: () => {
        callBack == null ? print("没有传递回调函数") : callBack()
      },
      child: Container(
          width: Constant.defaultWidth,
          height: 150.w,
          padding: EdgeInsets.only(top: 15.w, left: Constant.paddingLeftRight, right: Constant.paddingLeftRight,bottom: 8.w),
          decoration: const BoxDecoration(
              color: Colors.white
          ),
          child: Column(
            children: [
              CommonWidget.dividerWidget(),
              ListTile(
                contentPadding: EdgeInsets.only(top: 8.w, left: -25.w, right: -25.w),
                leading: leading != null ? Badge(
                  badgeContent: Text(tipNum??'0', style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                  showBadge : tipNum != null && tipNum != '0',
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: leadingBackgroundColor,
                        borderRadius: BorderRadius.circular(20.w)
                    ),
                    child: leading,
                  ),
                ) : null,
                title: desc != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                    SizedBox(height: 10.w,),
                    Text(desc, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 24.sp)),
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                  ],
                ),
                trailing: trailingTitle != null ? Container(
                  width: 100.w,
                  padding: EdgeInsets.only(top: 20.w),
                  alignment: Alignment.topCenter,
                  child: Text(trailingTitle, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 22.sp),),
                ) : null,
              )
            ],
          )
      ),
    );
  }

  /// 工作台图标显示
  /// @param {Color} backgroundColor 图标背景颜色
  /// @param {Widget} icon 图标
  /// @param {String} title 下面标题
  /// @param {Function} onclick 点击回调函数
  static Widget workBenchIcon({required Color backgroundColor, required Widget icon, required String title, Function? callBack}){
    return SizedBox(
      height: 160.0.w,
      width: 110.0.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () => {
                callBack == null ? print("没有传递回调函数") : callBack()
              },
              child: Container(
                width: 100.w,
                height: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20.w)
                ),
                child: icon,
              ),
          ),
          Container(
            margin: EdgeInsets.only(top:10.w),
            child: Center(
              child: Text(title,textAlign:TextAlign.center,style: TextStyle(fontSize: 22.sp, color: const Color.fromRGBO(32, 35, 40, 1)),),
            ),
          )
        ],
      ),
    );
  }

  /// 列表显示 - 通讯录列表
  /// @param {String} leadingUrl 左侧的图片地址
  /// @param {bool} hasDefault 是否需要默认图片
  /// @param {String} title 上面的文字
  /// @param {String} desc 下面的描述
  /// @param {String} trailingTitle 右侧显示
  /// @param {Function} onclick 点击回调函数
  static Widget listTileByUrl({ String? leadingUrl, bool hasDefault = false,required String title, String? desc, String? trailingTitle, Function? callBack}){
    return InkWell(
      onTap: () => {
        callBack == null ? print("没有传递回调函数") : callBack()
      },
      child: Container(
          width: Constant.defaultWidth,
          height: 150.w,
          padding: EdgeInsets.only(left: 40.w, right: 40.w,),
          decoration: const BoxDecoration(
              color: Colors.white
          ),
          child: Column(
            children: [
              CommonWidget.dividerWidget(),
              ListTile(
                contentPadding: EdgeInsets.only(top: 8.w, left: -25.w, right: -25.w),
                leading: imageWidget(imageUrl: leadingUrl, hasDefault: hasDefault),
                title: desc != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                    SizedBox(height: 15.w,),
                    Text(desc, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 24.sp)),
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                  ],
                ),
                trailing: trailingTitle != null ? Container(
                  width: 100.w,
                  padding: EdgeInsets.only(top: 20.w),
                  alignment: Alignment.topCenter,
                  child: Text(trailingTitle, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 22.sp),),
                ) : null,
              )
            ],
          )
      ),
    );
  }

  /// 对头像的处理
  /// @param {String} imageUrl 图片地址
  /// @param {bool} hasDefault 是否需要默认图片
  /// @param {double} width 宽度
  /// @param {double} height 高度
  /// @param {double} circular 圆角
  static Widget imageWidget({String? imageUrl, bool hasDefault = false, double? width, double? height, double? circular}){
    width ??= 100.w;
    height ??= 100.w;
    circular ??= 20.w;

    if (imageUrl != null && imageUrl != '' && StringUtil.isNetWorkImg(imageUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          width: width,
          height: height,
          // headers: CookieUtils.getHeaders(),
        ),
      );
    } else if(hasDefault) {
      return Image.asset(
        Constant.defaultUserAvatar,
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
    }
    return Container();
  }

  /// 简单列表处理 -- 图标和标题都在左边
  /// @param {String} icon 图标
  /// @param {String} title 标题
  /// @param {Function} callBack 回调
  static Widget simpleWidgetWithMine({Widget? icon, required String title, Function? callBack}){
    return InkWell(
      onTap: () => {
        callBack == null ? print("没有传递回调函数") : callBack()
      },
      child: Container(
        height: 100.w,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 1.w),
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.w),
              alignment: Alignment.centerLeft,
              child: icon ?? const Text(""),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  /// 简单列表处理 -- 左右分开
  /// @param {String} title 标题
  /// @param {String} value 值
  /// @param {bool} isImage 是否是图片
  /// @param {Function} callBack 回调
  static Widget simpleWidgetWithUserDetail(String title, {String? value, bool isImage = false, Function? callBack}){
    Widget child;
    if(isImage){
      if(callBack == null){
        child = CommonWidget.imageWidget(imageUrl: value, hasDefault: true, width: 60.w, height: 60.w);
      } else {
        child = Row(
          children: [
            CommonWidget.imageWidget(imageUrl: value, hasDefault: true, width: 60.w, height: 60.w),
            Icon(Icons.arrow_forward_ios_outlined, color: const Color.fromRGBO(144, 147, 153, 1), size: 30.w,)
          ],
        );
      }
    } else {
      if(callBack == null && value != null){
        child = Text(value, style: const TextStyle(color: Color.fromRGBO(144, 147, 153, 1)),);
      } else if(callBack != null){
        if(value != null){
          child = Row(
            children: [
              Text(value, style: const TextStyle(color: Color.fromRGBO(144, 147, 153, 1)),),
              Icon(Icons.arrow_forward_ios_outlined, color: const Color.fromRGBO(144, 147, 153, 1), size: 30.w,)
            ],
          );
        } else {
          child = Icon(Icons.arrow_forward_ios_outlined, color: const Color.fromRGBO(144, 147, 153, 1), size: 30.w,);
        }
      } else {
        child = const Text("");
      }
    }

    return  InkWell(
        onTap: () => {
          callBack == null ? print("没有传递回调函数") : callBack()
        },
        child:  Container(
          height: 100.w,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 1.w),
          decoration: const BoxDecoration(
              color: Colors.white
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 40.w),
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(color: Color.fromRGBO(80, 82, 86, 1)),),
              ),
              const Expanded(child: Text("")),
              Container(
                  padding: EdgeInsets.only(right: 40.w),
                  alignment: Alignment.centerLeft,
                  child: child
              ),
            ],
          ),
        )
    );
  }

  /// 按钮
  /// @param {String} title 按钮名称
  /// @param {Function} callBack 回调
  /// @param {Color} background 背景颜色
  /// @param {Color} fontColor 字体颜色
  static Widget buttonWidget({String title = '提交', Color background = const Color.fromRGBO(41, 121, 255, 1),
    Color fontColor = const Color(0xffffffff), Function? callBack, EdgeInsetsGeometry? margin, EdgeInsetsGeometry? padding}){
    margin ??= EdgeInsets.only(top: 50.w);
    padding ??= EdgeInsets.only(left: 40.w, right: 40.w);
    return Container(
      margin: margin,
      padding: padding,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(background),
        ),
        onPressed: (){
          callBack == null ? print("没有传递回调函数") : callBack();
        },
        child: Text(title, style: TextStyle(fontSize: 32.sp, color: fontColor),),
      ),
    );
  }

  /// 列表显示 - 我的 - 联系客服
  /// @param {Widget} leading 左侧的图标
  /// @param {Color} leadingBackgroundColor 图标的背景颜色
  /// @param {String} title 上面的文字
  /// @param {String} desc 下面的描述
  /// @param {String} trailingTitle 右侧显示
  /// @param {Function} onclick 点击回调函数
  static Widget listTileWithMine({Widget? leading, Color leadingBackgroundColor = const Color.fromRGBO(88, 202, 147, 1),
    required String title, String? desc, String? trailingTitle, Function? callBack}){
    return InkWell(
      onTap: () => {
        callBack == null ? print("没有传递回调函数") : callBack()
      },
      child: Container(
          width: Constant.defaultWidth,
          height: 150.w,
          margin: EdgeInsets.only(top: 20.w),
          padding: EdgeInsets.only(top: 15.w, left: Constant.paddingLeftRight, right: Constant.paddingLeftRight,bottom: 8.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(-5.w, 5.w),
                  blurRadius: 10.w,
                  spreadRadius: 5.w
                )
              ]
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(top: 8.w, left: -25.w, right: -25.w),
                leading: leading != null ? Container(
                  width: 100.w,
                  height: 100.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: leadingBackgroundColor,
                      border: Border(
                        right: BorderSide(
                          width: 2.w,
                          color: const Color.fromRGBO(229, 227, 227, 1)
                        )
                      )
                  ),
                  child: leading,
                ) : null,
                title: desc != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                    SizedBox(height: 10.w,),
                    Text(desc, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 24.sp)),
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: const Color.fromRGBO(32, 35, 40, 0.8), fontSize: 30.sp),),
                  ],
                ),
                trailing: trailingTitle != null ? Container(
                  width: 100.w,
                  padding: EdgeInsets.only(top: 20.w),
                  alignment: Alignment.topCenter,
                  child: Text(trailingTitle, style: TextStyle(color: const Color.fromRGBO(153, 153, 153, 1), fontSize: 22.sp),),
                ) : Icon(Icons.arrow_forward_ios_outlined, color: const Color.fromRGBO(144, 147, 153, 1), size: 30.w,),
              )
            ],
          )
      ),
    );
  }
}