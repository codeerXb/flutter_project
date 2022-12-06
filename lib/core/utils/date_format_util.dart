import 'package:date_format/date_format.dart';

/// 日期格式化
class DateFormatUtil{

  /// 转化 yyyy -> 2022
  static formatYYYY(DateTime dateTime){
    return formatDate(dateTime,['yyyy']);
  }

  /// 转化 yyyy -> 2002年
  static formatLocalYYYY(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '年']);
  }

  /// 转化 yyyy-MM -> 2022-07
  static formatYYYYmm(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '-', 'mm']);
  }

  /// 转化 yyyy-MM -> 2022年07月
  static formatLocalYYYYmm(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '年', 'mm', '月']);
  }

  /// 转化 yyyy-MM-dd -> 2022-07-01
  static formatYYYYmmdd(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '-', 'mm', '-', 'dd']);
  }

  /// 转化 yyyy-MM-dd -> 2022年07月01日
  static formatLocalYYYYmmdd(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '年', 'mm', '月', 'dd', '日']);
  }

  /// 转化 MM-dd -> 07-01
  static formatmmdd(DateTime dateTime){
    return formatDate(dateTime,['mm', '-', 'dd']);
  }

  /// 转化 MM-dd -> 07月01日
  static formatLocalmmdd(DateTime dateTime){
    return formatDate(dateTime,['mm', '月', 'dd', '日']);
  }

  /// 转化 yyyy-MM-dd HH:mm -> 2022-07-01 14:13
  static formatYYYYmmddHHnn(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '-', 'mm', '-', 'dd', ' ', 'HH', ':', 'nn']);
  }

  /// 转化 HH:mm -> 14:13
  static formatHHnn(DateTime dateTime){
    return formatDate(dateTime,['HH', ':', 'nn']);
  }

  /// 转化 HH:mm -> 14小时13分钟
  static formatLocalHHnn(DateTime dateTime){
    return formatDate(dateTime,['HH', '小时', 'nn', '分钟']);
  }

  /// 转化 yyyy-MM-dd HH:mm:ss -> 2022-07-01 14:13:20
  static formatYYYYmmddHHnnss(DateTime dateTime){
    return formatDate(dateTime,['yyyy', '-', 'mm', '-', 'dd', ' ', 'HH', ':', 'nn', ':', 'ss']);
  }

  /// 转化 HH:mm:ss -> 14:13:20
  static formatHHnnss(DateTime dateTime){
    return formatDate(dateTime,['HH', ':', 'nn', ':', 'ss']);
  }

}