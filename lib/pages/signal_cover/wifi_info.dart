import 'dart:async';
import 'package:flutter/services.dart';

class WifiInfoPlugin {
  static const MethodChannel _channel = MethodChannel('wifi_info_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///
  /// Wifi details  represents a case for a method that can be called in the method handler
  ///
  static Future<WifiInfoWrapper> get wifiDetails async {
    final Map<dynamic, dynamic> data =
        await _channel.invokeMethod('getWifiDetails');

    WifiInfoWrapper wifiWrapper = WifiInfoWrapper.withMap(data);
    return wifiWrapper;
  }
}

/// represents a wrapper object for mainly android wifi info class
class WifiInfoWrapper {
  String _bssid = "missing";
  String _ssid = "missing";
  String _ip = "missing";
  String _macAddress = "missing";
  int _linkSpeed = 0;
  int _singalStrength = 0;
  int _frequency = 0;
  int _networkid = 0;
  String _connectionType = "missing";
  bool _isHiddenSSID = false;
  String _routerIp = "unknown";
  String _dns1Ip = "";
  String _dns2Ip = "";

  WifiInfoWrapper();

  WifiInfoWrapper.withMap(Map<dynamic, dynamic> nativeInfo) {
    _bssid = nativeInfo["BSSID"];
    _ssid = nativeInfo["SSID"];
    _ip = nativeInfo["IP"];
    _macAddress = nativeInfo["MACADDRESS"];
    _linkSpeed = nativeInfo["LINKSPEED"];
    _singalStrength = nativeInfo["SIGNALSTRENGTH"];
    _frequency = nativeInfo["FREQUENCY"];
    _networkid = nativeInfo["NETWORKID"];
    _connectionType = nativeInfo["CONNECTIONTYPE"];
    _isHiddenSSID = nativeInfo["ISHIDDEDSSID"];
    _routerIp = nativeInfo["ROUTERIP"];
    _dns1Ip = nativeInfo["DNS1"];
    _dns2Ip = nativeInfo["DNS2"];
  }

  /// IPV4 address for connected device
  String get ipAddress {
    return _ip;
  }

  /// IPV4 address for router of the connected device
  String get routerIp {
    return _routerIp;
  }

  /// IPV4 address of the dns1 server
  String get dns1 {
    return _dns1Ip;
  }

  /// IPV4 address of the dns2 server
  String get dns2 {
    return _dns2Ip;
  }

  /// returns BSSID
  String get bssId {
    return _bssid;
  }

  /// returns the Name of the Network
  String get ssid {
    return _ssid;
  }

  ///returns device Mac Address
  String get macAddress {
    return _macAddress;
  }

  /// returns current link Speed
  int get linkSpeed {
    return _linkSpeed;
  }

  /// returns current signalStrength
  int get signalStrength {
    return _singalStrength;
  }

  /// returns current frequency
  int get frequency {
    return _frequency;
  }

  /// returns current Id of your network

  int get networkId {
    return _networkid;
  }

  /// returns connection type eg wifi or mobile
  String get connectionType {
    return _connectionType;
  }

  /// return boolean for  ssid  is hidden
  bool get isHiddenSSid {
    return _isHiddenSSID;
  }
}
