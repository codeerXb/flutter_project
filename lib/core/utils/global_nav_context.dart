import 'package:flutter/material.dart';

class GlobalContext {
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static final GlobalContext _instance = GlobalContext._();

  GlobalContext._();

  /// 赋值给根布局的 materialApp 上
  static GlobalKey<NavigatorState> get navigatorKey => _instance._navigatorKey;

  /// 可用于 跳转，overlay-insert（toast，loading） 使用
  static BuildContext? get navigatorContext => _instance._navigatorKey.currentState?.context;
}