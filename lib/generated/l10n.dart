// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `register`
  String get register {
    return Intl.message(
      'register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message(
      'skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `cpeManagementPlatform`
  String get cpeManagementPlatform {
    return Intl.message(
      'cpeManagementPlatform',
      name: 'cpeManagementPlatform',
      desc: '',
      args: [],
    );
  }

  /// `enter your mobile phone nubmer`
  String get phoneLabel {
    return Intl.message(
      'enter your mobile phone nubmer',
      name: 'phoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `the phone number is wrong`
  String get phoneError {
    return Intl.message(
      'the phone number is wrong',
      name: 'phoneError',
      desc: '',
      args: [],
    );
  }

  /// `enter your passworld`
  String get passworLdLabel {
    return Intl.message(
      'enter your passworld',
      name: 'passworLdLabel',
      desc: '',
      args: [],
    );
  }

  /// ` enter your passworld again`
  String get passWorLdAgain {
    return Intl.message(
      ' enter your passworld again',
      name: 'passWorLdAgain',
      desc: '',
      args: [],
    );
  }

  /// `The secondary code is inconsistent`
  String get passworLdAgainError {
    return Intl.message(
      'The secondary code is inconsistent',
      name: 'passworLdAgainError',
      desc: '',
      args: [],
    );
  }

  /// ` enter verification code`
  String get verficationCode {
    return Intl.message(
      ' enter verification code',
      name: 'verficationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code error`
  String get verficationCodeError {
    return Intl.message(
      'Verification code error',
      name: 'verficationCodeError',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get getVerficationCode {
    return Intl.message(
      'Verify Code',
      name: 'getVerficationCode',
      desc: '',
      args: [],
    );
  }

  /// `login successfully`
  String get loginSuccess {
    return Intl.message(
      'login successfully',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Discovery equipment' key

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'a ' key
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
