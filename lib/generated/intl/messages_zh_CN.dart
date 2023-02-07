// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cpeManagementPlatform":
            MessageLookupByLibrary.simpleMessage("CPE管理平台"),
        "getVerficationCode": MessageLookupByLibrary.simpleMessage("获取验证码"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
        "passWorLdAgain": MessageLookupByLibrary.simpleMessage("请再次输入登录密码"),
        "passworLdAgainError": MessageLookupByLibrary.simpleMessage("二次密码不一致"),
        "passworLdLabel": MessageLookupByLibrary.simpleMessage("请输入密码"),
        "phoneError": MessageLookupByLibrary.simpleMessage("手机号有误"),
        "phoneLabel": MessageLookupByLibrary.simpleMessage("请输入手机号"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "skip": MessageLookupByLibrary.simpleMessage("跳过"),
        "success": MessageLookupByLibrary.simpleMessage("成功"),
        "verficationCode": MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "verficationCodeError": MessageLookupByLibrary.simpleMessage("请输入正确验证码")
      };
}
