import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 缓存工具类
class CacheUtils {
  CacheUtils._internal();

  /// 获取缓存
  static Future<double> loadApplicationCache() async {
    /// 获取文件夹
    Directory? directory = Platform.isIOS ? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
    if(null != directory){
      /// 获取缓存大小
      return await _getTotalSizeOfFilesInDir(directory);
    }
   return 0;
  }

  /// 循环计算文件的大小（递归）
  static Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  /// 删除缓存
  static void clearApplicationCache() async {
    Directory? directory = Platform.isIOS ? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
    if(null != directory){
      //删除缓存目录
      await _deleteDirectory(directory);
    }
  }

  /// 递归方式删除目录
  static Future<void> _deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _deleteDirectory(child);
      }
    }
    await file.delete();
  }

}
