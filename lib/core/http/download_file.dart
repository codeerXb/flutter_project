import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/cookie_util.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/path_util.dart';
import '../utils/toast.dart';

/// 文件下载
class DownLoadFile{

  /// 下载方法
  static Future<void> downloadFile(fileUrl, fileName, context) async {
    ///1、权限检查
    bool checkPermission1 = await _checkPermission(context);
    if (checkPermission1) {
      /// 2、创建文件
      String dirloc = '${await PathUtils.getDocumentsDirPath()}${Platform.pathSeparator}Download';
      final savedDir = Directory(dirloc);
      /// 判断下载路径是否存在
      bool hasExisted = await savedDir.exists();
      /// 不存在就新建路径
      if (!hasExisted) {
        savedDir.create();
      }
      try {
        ToastUtils.showLoading();
        /// todo 这里可能需要修改header
        await FlutterDownloader.enqueue(
            url: fileUrl,//下载地址
            fileName: fileName,
            savedDir: dirloc,//保存路径
            showNotification: true, // show download progress in status bar (for Android)
            openFileFromNotification: true, // click on notification to open downloaded file (for Android)
            saveInPublicStorage: true,
            headers: await CookieUtils.getHeaders()
        );
      } catch (e) {
        ToastUtils.error(e.toString());
      }
    } else {
      ToastUtils.toast("没有权限，请打开存储权限！");
    }
  }

  /// 绑定并监听端口
  static bindBackgroundIsolate(context) {
    final ReceivePort port = ReceivePort();
    bool isSuccess = IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      DownLoadFile.unbindBackgroundIsolate();
      bindBackgroundIsolate(context);
      return;
    }
    port.listen((dynamic data) {
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      if (status == DownloadTaskStatus.complete) {
        dismissAllToast();
        sleep(const Duration(seconds: 1));
        _showDialogCum(id, context);
      }
    });
    FlutterDownloader.registerCallback(_downloadCallback);
  }

  /// 去除监听
  static unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  /// 弹出层，提示打开文件
  static _showDialogCum(taskId, BuildContext context){
    ToastUtils.showDialogPopup(context, "需要立即打开吗？", title: "下载完成提示", successCallback: (){
      _openDownloadedFile(taskId).then((success){
        if(!success){
          ToastUtils.toast("你的手机暂不支持该文件格式的打开");
        }
      });
    });
  }

  /// 注册回调方法
  static _downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  ///判断权限
  static Future<bool> _checkPermission(context) async {
    /// 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      /// 检查是否已有读写内存的权限
      return await Permission.storage.request().isGranted;
    } else {
      return true;
    }
  }

  /// 根据taskId打开下载文件
  static Future<bool> _openDownloadedFile(taskId){
    return FlutterDownloader.open(taskId: taskId);
  }
}