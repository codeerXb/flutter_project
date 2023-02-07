// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cpeManagementPlatform":
            MessageLookupByLibrary.simpleMessage("cpeManagementPlatform"),
        "getVerficationCode":
            MessageLookupByLibrary.simpleMessage("Verify Code"),
        "login": MessageLookupByLibrary.simpleMessage("login"),
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("login successfully"),
        "passWorLdAgain":
            MessageLookupByLibrary.simpleMessage(" enter your passworld again"),
        "passworLdAgainError": MessageLookupByLibrary.simpleMessage(
            "The secondary code is inconsistent"),
        "passworLdLabel":
            MessageLookupByLibrary.simpleMessage("enter your passworld"),
        "phoneError":
            MessageLookupByLibrary.simpleMessage("the phone number is wrong"),
        "phoneLabel": MessageLookupByLibrary.simpleMessage(
            "enter your mobile phone nubmer"),
        "register": MessageLookupByLibrary.simpleMessage("register"),
        "skip": MessageLookupByLibrary.simpleMessage("skip"),
        "success": MessageLookupByLibrary.simpleMessage("success"),
        "verficationCode":
            MessageLookupByLibrary.simpleMessage(" enter verification code"),
        "verficationCodeError":
            MessageLookupByLibrary.simpleMessage("Verification code error")
      };
}
