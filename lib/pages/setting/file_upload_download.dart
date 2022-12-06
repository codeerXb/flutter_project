import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart' as getx;
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/constant.dart';
import '../../core/http/download_file.dart';
import '../../core/utils/path_util.dart';
import '../../core/widget/custom_app_bar.dart';

/// 文件上传与下载
class FileUploadDownload extends StatefulWidget {
  const FileUploadDownload({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileUploadDownloadState();
}

class _FileUploadDownloadState extends State<FileUploadDownload> {
  /// 单选上传的文件
  Map<String, dynamic> singleFileMap = {};

  /// 多选上传的文件
  Map<String, dynamic> multipleFileMap = {};

  /// 定位对象
  Location? _location;

  /// 电子围栏信息
  GeoFenceEvent? geoFenceEvent;

  @override
  void initState() {
    super.initState();

    /// 初始化下载插件
    DownLoadFile.bindBackgroundIsolate(context);
    // _startLocation();
  }

  @override
  void dispose() {
    if (mounted) {
      DownLoadFile.unbindBackgroundIsolate();
      _stopLocation();
      AmapLocation.instance.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '文件上传与下载'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 下载文件
            downloadFile(),

            /// 下载文件2
            downloadFile2(),

            /// 单文件上传
            singleUploadFile(),

            /// 多文件上传
            multipleUploadFile(),

            /// 显示laoding
            showLoading(),

            /// 隐藏laoding
            hideLoading(),

            /// 定位
            locationWidget(),
          ],
        ),
      ),
    );
  }

  /// 下载1
  downloadFile() {
    return Container(
      height: 80.w,
      padding: EdgeInsets.only(
          left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
      child: Row(
        children: [
          const Text("这是一个测试图片1"),
          const Expanded(child: Text("")),
          TextButton(
            onPressed: () async {
              String dirloc =
                  '${await PathUtils.getDocumentsDirPath()}${Platform.pathSeparator}22.jpg';
              print("下载路径：$dirloc");
              XHttp.downloadFile(
                  "http://f.hiphotos.baidu.com/image/pic/item/4034970a304e251f503521f5a586c9177e3e53f9.jpg",
                  dirloc);
            },
            child: const Text("下载"),
          )
        ],
      ),
    );
  }

  /// 下载2
  downloadFile2() {
    return Container(
      height: 80.w,
      padding: EdgeInsets.only(
          left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
      child: Row(
        children: [
          const Text("这是一个测试图片2"),
          const Expanded(child: Text("")),
          TextButton(
            onPressed: () async {
              DownLoadFile.downloadFile(
                  "http://a.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a292d2472199d25bc315d607c7c.jpg",
                  "${Random().nextInt(2000)}.jpg",
                  context);
            },
            child: const Text("下载2"),
          )
        ],
      ),
    );
  }

  /// 显示loading
  showLoading() {
    return TextButton(
      onPressed: () {
        ToastUtils.showLoading();
      },
      child: const Text("显示loading"),
    );
  }

  /// 隐藏loading
  hideLoading() {
    return TextButton(
      onPressed: () {
        dismissAllToast();
      },
      child: const Text("隐藏loading"),
    );
  }

  /// 单文件上传
  singleUploadFile() {
    return Container(
        padding: EdgeInsets.only(
            left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [
                        'jpg',
                        'png',
                        'pdf',
                        'doc',
                        'docx',
                        'xls',
                        'txt',
                        'xlsx',
                        'zip',
                        'rar'
                      ],
                    );
                    if (result != null) {
                      print("单文件上传的文件信息：$result.files.single");
                      setState(() {
                        singleFileMap.putIfAbsent(result.files.single.name,
                            () => result.files.single.path);
                      });
                    }
                  },
                  child: const Text("单文件上传"),
                ),
                TextButton(
                    onPressed: () {
                      submitFile(singleFileMap);
                    },
                    child: const Text("上传")),
              ],
            ),
            Column(children: fileWidget(singleFileMap))
          ],
        ));
  }

  /// 多文件上传
  multipleUploadFile() {
    return Container(
        padding: EdgeInsets.only(
            left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: [
                        'jpg',
                        'png',
                        'pdf',
                        'doc',
                        'docx',
                        'xls',
                        'txt',
                        'xlsx',
                        'zip',
                        'rar'
                      ],
                    );
                    if (result != null) {
                      print("多文件上传文件信息：$result.files");
                      for (var file in result.files) {
                        setState(() {
                          multipleFileMap.putIfAbsent(
                              file.name, () => file.path);
                        });
                      }
                    }
                  },
                  child: const Text("多文件上传"),
                ),
                TextButton(
                    onPressed: () {
                      submitFile(multipleFileMap);
                    },
                    child: const Text("上传")),
              ],
            ),
            Column(children: fileWidget(multipleFileMap))
          ],
        ));
  }

  /// 显示上传文件
  fileWidget(Map<String, dynamic> fileMap) {
    List<Widget> list = [];
    fileMap.forEach((fileName, filePath) {
      list.add(Container(
        padding: EdgeInsets.only(
            left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fileName),
            TextButton(
                onPressed: () {
                  setState(() {
                    fileMap.remove(fileName);
                  });
                },
                child: const Text("删除")),
          ],
        ),
      ));
    });
    return list;
  }

  /// 上传文件 根据自己需要组装数据
  submitFile(Map<String, dynamic> fileMap) {
    List<MultipartFile> multipartFiles = [];
    fileMap.forEach((key, value) {
      multipartFiles.add(MultipartFile.fromFileSync(value, filename: key));
    });
    Map<String, dynamic> mapFileDatas = {"files": multipartFiles};
    print("上传数据：$multipartFiles");

    /// 上传
    if (false) {
      XHttp.uploadFile("/upload", mapFileDatas);
    }
  }

  /// 定位
  locationWidget() {
    return Container(
        padding: EdgeInsets.only(
            left: Constant.paddingLeftRight, right: Constant.paddingLeftRight),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _startLocation,
                  child: const Text("开始定位"),
                ),
                TextButton(
                  onPressed: _addCircleGeoFence,
                  child: const Text("添加圆形围栏 100m"),
                ),
                TextButton(onPressed: _stopLocation, child: const Text("停止定位")),
              ],
            ),
            Text("定位位置信息：$_location"),
            Text("围栏信息：$geoFenceEvent"),
          ],
        ));
  }

  /// 动态申请定位权限
  _requestPermission() async {
    /// 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (!hasLocationPermission) {
      // ignore: use_build_context_synchronously
      ToastUtils.showDialogPopup(context, "您已拒绝位置定位权限, 请在设置中心同意app的权限请求. ",
          leftBtnText: "退出", rightBtnText: "去设置中心", successCallback: () async {
        /// 去设置中心操作
        /// 去设置中心  也是使用到了权限管理的包
        bool flag = await openAppSettings();
        if (!flag) {
          ToastUtils.toast("您的手机暂时不支持应用程序设置");
          getx.Get.back();
        }
      }, cancelCallback: () {
        /// 退出操作
        getx.Get.back();
      });
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    ///获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      ///已经授权
      return true;
    } else {
      ///未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    }
  }

  ///开始定位
  _startLocation() async {
    ///开始定位之前设置定位参数
    await _requestPermission();
    // final location = await AmapLocation.instance.fetchLocation();
    // setState(() => _location = location);
    // 监听定位
    AmapLocation.instance
        .listenLocation(
            mode: LocationAccuracy.High, needAddress: true, interval: 2000)
        .listen((event) => setState(() => _location = event));
  }

  ///停止定位
  _stopLocation() async {
    await AmapLocation.instance.stopLocation();
  }

  /// 圆形围栏
  /// radius 半径
  /// longitude latitude 经纬度
  _addCircleGeoFence(
      {double radius = 100,
      double longitude = 116.473115,
      double latitude = 39.993207}) async {
    /// 获取当前位置
    await _requestPermission();
    // 可通过状态判断是否在范围之内
    AmapLocation.instance
        .addCircleGeoFence(
      center: LatLng(latitude, longitude),
      radius: radius,
      customId: 'testid',
    )
        .listen((event) {
      setState(() {
        geoFenceEvent = event;
      });
      print(
          '状态: ${event.status}, 围栏id: ${event.fenceId}, 自定义id: ${event.customId}');
    });
  }
}
