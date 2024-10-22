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

  /// `Incorrect account or password`
  String get accountOrPwdError {
    return Intl.message(
      'Incorrect account or password',
      name: 'accountOrPwdError',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics Authenticate`
  String get biometrics {
    return Intl.message(
      'Authentication',
      name: 'biometrics',
      desc: '',
      args: [],
    );
  }

  /// `ACCOUNT AND PROFILE`
  String get profile {
    return Intl.message(
      'ACCOUNT AND PROFILE',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE`
  String get update {
    return Intl.message(
      'UPDATE',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Home Address`
  String get homeAddress {
    return Intl.message(
      'Home Address',
      name: 'homeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Please connect the current device to a Wi-Fi network before proceeding`
  String get warningSnNotSame {
    return Intl.message(
      'Please connect the current device to a Wi-Fi network before proceeding',
      name: 'warningSnNotSame',
      desc: '',
      args: [],
    );
  }

  /// `Device Exception`
  String get deviceException {
    return Intl.message(
      'Device Exception',
      name: 'deviceException',
      desc: '',
      args: [],
    );
  }

  /// `Please reconnect device`
  String get reconnectDevice {
    return Intl.message(
      'Please reconnect device',
      name: 'reconnectDevice',
      desc: '',
      args: [],
    );
  }

  /// `Remote access refused`
  String get accessRefused {
    return Intl.message(
      'Remote access refused',
      name: 'accessRefused',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete`
  String get delPro {
    return Intl.message(
      'Are you sure you want to delete',
      name: 'delPro',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi Mapping`
  String get wifiMapping {
    return Intl.message(
      'Wi-Fi Mapping',
      name: 'wifiMapping',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get loginFailed {
    return Intl.message(
      'Login Failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Binding CPE failed: The CPE device has already been bound.`
  String get deviceBinded {
    return Intl.message(
      'Binding CPE failed: The CPE device has already been bound.',
      name: 'deviceBinded',
      desc: '',
      args: [],
    );
  }

  /// `NetWork Error`
  String get netError {
    return Intl.message(
      'NetWork Error',
      name: 'netError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get autoLang {
    return Intl.message(
      'Auto',
      name: 'autoLang',
      desc: '',
      args: [],
    );
  }

  /// `Login has expired`
  String get tokenExpired {
    return Intl.message(
      'Login has expired',
      name: 'tokenExpired',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get addDevice {
    return Intl.message(
      'Add Device',
      name: 'addDevice',
      desc: '',
      args: [],
    );
  }

  /// `List of Bound Items`
  String get list {
    return Intl.message(
      'List of Bound Items',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get the bound device`
  String get failed {
    return Intl.message(
      'Failed to get the bound device',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Unkown Error`
  String get unkownFail {
    return Intl.message(
      'Unkown Error',
      name: 'unkownFail',
      desc: '',
      args: [],
    );
  }

  /// `Request Failed`
  String get requestFailed {
    return Intl.message(
      'Request Failed',
      name: 'requestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Subscriber Login`
  String get userLogin {
    return Intl.message(
      'Subscriber Login',
      name: 'userLogin',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cpeManagementPlatform {
    return Intl.message(
      '',
      name: 'cpeManagementPlatform',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email or phone nubmer`
  String get phoneLabel {
    return Intl.message(
      'Enter your email or phone nubmer',
      name: 'phoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please input email or phone number`
  String get phoneError {
    return Intl.message(
      'Please input email or phone number',
      name: 'phoneError',
      desc: '',
      args: [],
    );
  }

  /// `Please input correct email or phone number`
  String get accountIncorrect {
    return Intl.message(
      'Please input correct email or phone number',
      name: 'accountIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordLabel {
    return Intl.message(
      'Enter your password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// ` Enter your password again`
  String get passwordAgain {
    return Intl.message(
      ' Enter your password again',
      name: 'passwordAgain',
      desc: '',
      args: [],
    );
  }

  /// `The secondary code is inconsistent`
  String get passwordAgainError {
    return Intl.message(
      'The secondary code is inconsistent',
      name: 'passwordAgainError',
      desc: '',
      args: [],
    );
  }

  /// ` Enter verification code`
  String get verficationCode {
    return Intl.message(
      ' Enter verification code',
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

  /// `Login Success`
  String get loginSuccess {
    return Intl.message(
      'Login Success',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Looking for your Wi-Fi`
  String get DiscoveryEqu {
    return Intl.message(
      'Looking for your Wi-Fi',
      name: 'DiscoveryEqu',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Connect Device`
  String get conDev {
    return Intl.message(
      'Connect Device',
      name: 'conDev',
      desc: '',
      args: [],
    );
  }

  /// `Scanning in progress`
  String get Scanning {
    return Intl.message(
      'Scanning in progress',
      name: 'Scanning',
      desc: '',
      args: [],
    );
  }

  /// `Device not found`
  String get noDevice {
    return Intl.message(
      'Device not found',
      name: 'noDevice',
      desc: '',
      args: [],
    );
  }

  /// `Rescan`
  String get rescan {
    return Intl.message(
      'Rescan',
      name: 'rescan',
      desc: '',
      args: [],
    );
  }

  /// `Unbind Device`
  String get UntyingEqui {
    return Intl.message(
      'Unbind Device',
      name: 'UntyingEqui',
      desc: '',
      args: [],
    );
  }

  /// `Unbind Error`
  String get unbindError {
    return Intl.message(
      'Unbind Error',
      name: 'unbindError',
      desc: '',
      args: [],
    );
  }

  /// `WLAN Setting`
  String get wlanSet {
    return Intl.message(
      'WLAN Setting',
      name: 'wlanSet',
      desc: '',
      args: [],
    );
  }

  /// `Guest Network`
  String get visitorNet {
    return Intl.message(
      'Guest Network',
      name: 'visitorNet',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get majorSet {
    return Intl.message(
      'Region',
      name: 'majorSet',
      desc: '',
      args: [],
    );
  }

  /// `WPS`
  String get wpsSet {
    return Intl.message(
      'WPS',
      name: 'wpsSet',
      desc: '',
      args: [],
    );
  }

  /// `Device Information`
  String get deviceInfo {
    return Intl.message(
      'Device Information',
      name: 'deviceInfo',
      desc: '',
      args: [],
    );
  }

  /// `System Information`
  String get systemInfo {
    return Intl.message(
      'System Information',
      name: 'systemInfo',
      desc: '',
      args: [],
    );
  }

  /// `Version Information`
  String get versionInfo {
    return Intl.message(
      'Version Information',
      name: 'versionInfo',
      desc: '',
      args: [],
    );
  }

  /// `LAN Status`
  String get lanStatus {
    return Intl.message(
      'LAN Status',
      name: 'lanStatus',
      desc: '',
      args: [],
    );
  }

  /// `Ethernet`
  String get Ethernet {
    return Intl.message(
      'Ethernet',
      name: 'Ethernet',
      desc: '',
      args: [],
    );
  }

  /// `WAN Status`
  String get EthernetStatus {
    return Intl.message(
      'WAN Status',
      name: 'EthernetStatus',
      desc: '',
      args: [],
    );
  }

  /// `Ethernet Settings`
  String get EthernetSettings {
    return Intl.message(
      'Ethernet Settings',
      name: 'EthernetSettings',
      desc: '',
      args: [],
    );
  }

  /// `Network`
  String get netSet {
    return Intl.message(
      'Network',
      name: 'netSet',
      desc: '',
      args: [],
    );
  }

  /// `WAN Settings`
  String get wanSettings {
    return Intl.message(
      'WAN Settings',
      name: 'wanSettings',
      desc: '',
      args: [],
    );
  }

  /// `DNS Settings`
  String get dnsSettings {
    return Intl.message(
      'DNS Settings',
      name: 'dnsSettings',
      desc: '',
      args: [],
    );
  }

  /// `Radio Settings`
  String get radioSettings {
    return Intl.message(
      'Radio Settings',
      name: 'radioSettings',
      desc: '',
      args: [],
    );
  }

  /// `LAN Settings`
  String get lanSettings {
    return Intl.message(
      'LAN Settings',
      name: 'lanSettings',
      desc: '',
      args: [],
    );
  }

  /// `LAN host settings`
  String get lanHostSettings {
    return Intl.message(
      'LAN host settings',
      name: 'lanHostSettings',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get maintainSettings {
    return Intl.message(
      'Maintenance',
      name: 'maintainSettings',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountSecurity {
    return Intl.message(
      'Account',
      name: 'accountSecurity',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get SystemSettings {
    return Intl.message(
      'System',
      name: 'SystemSettings',
      desc: '',
      args: [],
    );
  }

  String get RouterUpgrade {
    return Intl.message(
      'Router Upgrade',
      name: 'RouterUpgrade',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message(
      'Clear Cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  // Account Deletion
  String get delAccount {
    return Intl.message(
      'Account Deletion',
      name: 'delAccount',
      desc: '',
      args: [],
    );
  }

  /// `Network Status`
  String get state {
    return Intl.message(
      'Network Status',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Home Network`
  String get netTopo {
    return Intl.message(
      'Home Network',
      name: 'netTopo',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Settings`
  String get advancedSet {
    return Intl.message(
      'Advanced Settings',
      name: 'advancedSet',
      desc: '',
      args: [],
    );
  }

  /// `General Settings`
  String get General {
    return Intl.message(
      'General Settings',
      name: 'General',
      desc: '',
      args: [],
    );
  }

  /// `Band`
  String get Band {
    return Intl.message(
      'Band',
      name: 'Band',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get Mode {
    return Intl.message(
      'Mode',
      name: 'Mode',
      desc: '',
      args: [],
    );
  }

  /// `Bandwidth`
  String get Bandwidth {
    return Intl.message(
      'Bandwidth',
      name: 'Bandwidth',
      desc: '',
      args: [],
    );
  }

  /// `Channel`
  String get Channel {
    return Intl.message(
      'Channel',
      name: 'Channel',
      desc: '',
      args: [],
    );
  }

  /// `TX Power`
  String get TxPower {
    return Intl.message(
      'TX Power',
      name: 'TxPower',
      desc: '',
      args: [],
    );
  }

  /// `Configuration`
  String get Configuration {
    return Intl.message(
      'Configuration',
      name: 'Configuration',
      desc: '',
      args: [],
    );
  }

  /// `Maximum number of devices`
  String get Maximum {
    return Intl.message(
      'Maximum number of devices',
      name: 'Maximum',
      desc: '',
      args: [],
    );
  }

  /// `1-64`
  String get MaximumRange {
    return Intl.message(
      '1-32',
      name: 'MaximumRange',
      desc: '',
      args: [],
    );
  }

  /// `Hide SSID broadcast`
  String get HideSSIDBroadcast {
    return Intl.message(
      'Hide SSID broadcast',
      name: 'HideSSIDBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `AP Isolation`
  String get APIsolation {
    return Intl.message(
      'AP Isolation',
      name: 'APIsolation',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get Security {
    return Intl.message(
      'Security',
      name: 'Security',
      desc: '',
      args: [],
    );
  }

  /// `WPA Encryption`
  String get WPAEncry {
    return Intl.message(
      'WPA Encryption',
      name: 'WPAEncry',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get notEnable {
    return Intl.message(
      'Disabled',
      name: 'notEnable',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Visitor network index`
  String get NetworkIndex {
    return Intl.message(
      'Visitor network index',
      name: 'NetworkIndex',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to the intranet`
  String get AllowAccess {
    return Intl.message(
      'Allow access to the intranet',
      name: 'AllowAccess',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get Region {
    return Intl.message(
      'Region',
      name: 'Region',
      desc: '',
      args: [],
    );
  }

  /// `Client PIN`
  String get ClientPIN {
    return Intl.message(
      'Client PIN',
      name: 'ClientPIN',
      desc: '',
      args: [],
    );
  }

  /// `Running Time`
  String get RunningTime {
    return Intl.message(
      'Running Time',
      name: 'RunningTime',
      desc: '',
      args: [],
    );
  }

  /// `Product Model`
  String get ProductModel {
    return Intl.message(
      'Product Model',
      name: 'ProductModel',
      desc: '',
      args: [],
    );
  }

  /// `Hardware Version`
  String get HardwareVersion {
    return Intl.message(
      'Hardware Version',
      name: 'HardwareVersion',
      desc: '',
      args: [],
    );
  }

  /// `Software Version`
  String get SoftwareVersion {
    return Intl.message(
      'Software Version',
      name: 'SoftwareVersion',
      desc: '',
      args: [],
    );
  }

  /// `UBOOT Version`
  String get UBOOTVersion {
    return Intl.message(
      'UBOOT Version',
      name: 'UBOOTVersion',
      desc: '',
      args: [],
    );
  }

  /// `Serial Number`
  String get SerialNumber {
    return Intl.message(
      'Serial Number',
      name: 'SerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `MAC Address`
  String get MACAddress {
    return Intl.message(
      'MAC Address',
      name: 'MACAddress',
      desc: '',
      args: [],
    );
  }

  String get Enabled {
    return Intl.message(
      'Enabled',
      name: 'Enabled',
      desc: '',
      args: [],
    );
  }

  /// `IP Address`
  String get IPAddress {
    return Intl.message(
      'IP Address',
      name: 'IPAddress',
      desc: '',
      args: [],
    );
  }

  /// `Subnet Mask`
  String get SubnetMask {
    return Intl.message(
      'Subnet Mask',
      name: 'SubnetMask',
      desc: '',
      args: [],
    );
  }

  String get UpStream {
    return Intl.message(
      'UpStream',
      name: 'UpStream',
      desc: '',
      args: [],
    );
  }

  String get DownStream {
    return Intl.message(
      'DownStream',
      name: 'DownStream',
      desc: '',
      args: [],
    );
  }

  /// `Network Mode`
  String get NetworkMode {
    return Intl.message(
      'Network Mode',
      name: 'NetworkMode',
      desc: '',
      args: [],
    );
  }

  /// `Primary DNS`
  String get PrimaryDNS {
    return Intl.message(
      'Primary DNS',
      name: 'PrimaryDNS',
      desc: '',
      args: [],
    );
  }

  /// `Secondary DNS`
  String get SecondaryDNS {
    return Intl.message(
      'Secondary DNS',
      name: 'SecondaryDNS',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Connect Method`
  String get connectMethod {
    return Intl.message(
      'Connect Method',
      name: 'connectMethod',
      desc: '',
      args: [],
    );
  }

  /// `GSCNARFCN`
  String get GSCNARFCN {
    return Intl.message(
      'GSCNARFCN',
      name: 'GSCNARFCN',
      desc: '',
      args: [],
    );
  }

  /// `DL Frequency`
  String get DLFrequency {
    return Intl.message(
      'DL Frequency',
      name: 'DLFrequency',
      desc: '',
      args: [],
    );
  }

  /// `UL Frequency`
  String get ULFrequency {
    return Intl.message(
      'UL Frequency',
      name: 'ULFrequency',
      desc: '',
      args: [],
    );
  }

  /// `Up`
  String get ULVelocity {
    return Intl.message(
      'Up',
      name: 'ULVelocity',
      desc: '',
      args: [],
    );
  }

  /// `Down`
  String get DLVelocity {
    return Intl.message(
      'Down',
      name: 'DLVelocity',
      desc: '',
      args: [],
    );
  }

  /// `Start iP address`
  String get startIPAddress {
    return Intl.message(
      'Start iP address',
      name: 'startIPAddress',
      desc: '',
      args: [],
    );
  }

  /// `End iP address`
  String get endIPAddress {
    return Intl.message(
      'End iP address',
      name: 'endIPAddress',
      desc: '',
      args: [],
    );
  }

  /// `Lease Time`
  String get LeaseTime {
    return Intl.message(
      'Lease Time',
      name: 'LeaseTime',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message(
      'Minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Server`
  String get server {
    return Intl.message(
      'Server',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Connection Mode`
  String get connectionMode {
    return Intl.message(
      'Connection Mode',
      name: 'connectionMode',
      desc: '',
      args: [],
    );
  }

  /// `Link Status`
  String get linkStatus {
    return Intl.message(
      'Link Status',
      name: 'linkStatus',
      desc: '',
      args: [],
    );
  }

  String get UpTime {
    return Intl.message(
      'UpTime',
      name: 'UpTime',
      desc: '',
      args: [],
    );
  }

  /// `Connect Status`
  String get connectStatus {
    return Intl.message(
      'Connect Status',
      name: 'connectStatus',
      desc: '',
      args: [],
    );
  }

  /// `Online Time`
  String get OnlineTime {
    return Intl.message(
      'Online Time',
      name: 'OnlineTime',
      desc: '',
      args: [],
    );
  }

  /// `Default Gateway`
  String get DefaultGateway {
    return Intl.message(
      'Default Gateway',
      name: 'DefaultGateway',
      desc: '',
      args: [],
    );
  }

  String get ByteReceive {
    return Intl.message(
      'Bytes Received',
      name: 'BytesReceive',
      desc: '',
      args: [],
    );
  }

   String get ByteSent {
    return Intl.message(
      'Bytes Sent',
      name: 'BytesSent',
      desc: '',
      args: [],
    );
  }

  String get  PacketReceive {
    return Intl.message(
      'Packets Received',
      name: 'PacketsReceive',
      desc: '',
      args: [],
    );
  }

  String get PacketSent {
    return Intl.message(
      'Packets Sent',
      name: 'PacketsSent',
      desc: '',
      args: [],
    );
  }

  /// `Ethernet Only`
  String get EthernetOnly {
    return Intl.message(
      'Ethernet Only',
      name: 'EthernetOnly',
      desc: '',
      args: [],
    );
  }

  /// `Detect Server`
  String get Detect {
    return Intl.message(
      'Detect Server',
      name: 'Detect',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message(
      'Priority',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `Current Device`
  String get currentDeive {
    return Intl.message(
      'Current Device',
      name: 'currentDeive',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Please login`
  String get noLogin {
    return Intl.message(
      'Please login',
      name: 'noLogin',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get timeOnline {
    return Intl.message(
      'Online',
      name: 'timeOnline',
      desc: '',
      args: [],
    );
  }

  /// `Package Setting`
  String get PackageSetting {
    return Intl.message(
      'Package Setting',
      name: 'PackageSetting',
      desc: '',
      args: [],
    );
  }

  /// `AES(Recommened)`
  String get aesRecommend {
    return Intl.message(
      'AES(Recommended)',
      name: 'aesRecommend',
      desc: '',
      args: [],
    );
  }

  /// `None(Not Recommened)`
  String get emptyNORecommend {
    return Intl.message(
      'None(Not Recommended)',
      name: 'emptyNORecommend',
      desc: '',
      args: [],
    );
  }

  /// `Type of package`
  String get TypeOfPackage {
    return Intl.message(
      'Type of package',
      name: 'TypeOfPackage',
      desc: '',
      args: [],
    );
  }

  /// `Package Capacity`
  String get PackageCapacity {
    return Intl.message(
      'Package Capacity',
      name: 'PackageCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Package Duration`
  String get PackageDuration {
    return Intl.message(
      'Package Duration',
      name: 'PackageDuration',
      desc: '',
      args: [],
    );
  }

  /// `Package Cycle`
  String get cycle {
    return Intl.message(
      'Package Cycle',
      name: 'cycle',
      desc: '',
      args: [],
    );
  }

  /// `Traffic Package`
  String get TotalPackageQuantity {
    return Intl.message(
      'Traffic Package',
      name: 'TotalPackageQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get month {
    return Intl.message(
      'Mon',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Statistics by flow`
  String get StatisticsByFlow {
    return Intl.message(
      'Statistics by flow',
      name: 'StatisticsByFlow',
      desc: '',
      args: [],
    );
  }

  /// `Time length statistics`
  String get TimeLengthStatistics {
    return Intl.message(
      'Time length statistics',
      name: 'TimeLengthStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get Connected {
    return Intl.message(
      'Connected',
      name: 'Connected',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected`
  String get ununited {
    return Intl.message(
      'Disconnected',
      name: 'ununited',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic IP`
  String get DynamicIP {
    return Intl.message(
      'Dynamic IP',
      name: 'DynamicIP',
      desc: '',
      args: [],
    );
  }

  /// `StaticIP`
  String get staticIP {
    return Intl.message(
      'StaticIP',
      name: 'staticIP',
      desc: '',
      args: [],
    );
  }

  /// `LAN Only`
  String get LANOnly {
    return Intl.message(
      'LAN Only',
      name: 'LANOnly',
      desc: '',
      args: [],
    );
  }

  /// `BRIDGE`
  String get BRIDGE {
    return Intl.message(
      'BRIDGE',
      name: 'BRIDGE',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get Auto {
    return Intl.message(
      'Auto',
      name: 'Auto',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get Manual {
    return Intl.message(
      'Manual',
      name: 'Manual',
      desc: '',
      args: [],
    );
  }

  /// `China`
  String get China {
    return Intl.message(
      'China',
      name: 'China',
      desc: '',
      args: [],
    );
  }

  /// `France`
  String get France {
    return Intl.message(
      'France',
      name: 'France',
      desc: '',
      args: [],
    );
  }

  /// `Russia`
  String get Russia {
    return Intl.message(
      'Russia',
      name: 'Russia',
      desc: '',
      args: [],
    );
  }

  /// `United States`
  String get UnitedStates {
    return Intl.message(
      'United States',
      name: 'UnitedStates',
      desc: '',
      args: [],
    );
  }

  /// `Singapore`
  String get Singapore {
    return Intl.message(
      'Singapore',
      name: 'Singapore',
      desc: '',
      args: [],
    );
  }

  /// `Australia`
  String get Australia {
    return Intl.message(
      'Australia',
      name: 'Australia',
      desc: '',
      args: [],
    );
  }

  /// `Chile`
  String get Chile {
    return Intl.message(
      'Chile',
      name: 'Chile',
      desc: '',
      args: [],
    );
  }

  /// `Poland`
  String get Poland {
    return Intl.message(
      'Poland',
      name: 'Poland',
      desc: '',
      args: [],
    );
  }

  /// `Reboot Scheduler`
  String get RebootScheduler {
    return Intl.message(
      'Reboot Scheduler',
      name: 'RebootScheduler',
      desc: '',
      args: [],
    );
  }

  /// `Enable reboot scheduler`
  String get EnableRebootScheduler {
    return Intl.message(
      'Enable reboot scheduler',
      name: 'EnableRebootScheduler',
      desc: '',
      args: [],
    );
  }

  /// `Reboot`
  String get Reboot {
    return Intl.message(
      'Reboot',
      name: 'Reboot',
      desc: '',
      args: [],
    );
  }

  /// `Please click reboot to reboot device`
  String get clickReboot {
    return Intl.message(
      'Please click reboot to reboot device',
      name: 'clickReboot',
      desc: '',
      args: [],
    );
  }

  /// `Factory Reset`
  String get FactoryReset {
    return Intl.message(
      'Factory Reset',
      name: 'FactoryReset',
      desc: '',
      args: [],
    );
  }

  /// `Please click factory reset to restore device to its factory settings`
  String get clickFactory {
    return Intl.message(
      'Please click factory reset to restore device to its factory settings',
      name: 'clickFactory',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to unbind the current device`
  String get unblockdevice {
    return Intl.message(
      'Confirm to unbind the current device',
      name: 'unblockdevice',
      desc: '',
      args: [],
    );
  }

  /// `Binding?`
  String get binding {
    return Intl.message(
      'Binding?',
      name: 'binding',
      desc: '',
      args: [],
    );
  }

  /// `Hint`
  String get hint {
    return Intl.message(
      'Tip',
      name: 'Tip',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get set {
    return Intl.message(
      'Devices',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Not Set`
  String get Notset {
    return Intl.message(
      'Not Set',
      name: 'Notset',
      desc: '',
      args: [],
    );
  }

  /// `Used Traffic`
  String get UsedFlow {
    return Intl.message(
      'Used Traffic',
      name: 'UsedFlow',
      desc: '',
      args: [],
    );
  }

  /// `Elapsed Time`
  String get ElapsedTime {
    return Intl.message(
      'Elapsed Time',
      name: 'ElapsedTime',
      desc: '',
      args: [],
    );
  }

  /// `Self Checking`
  String get Intest {
    return Intl.message(
      'Self Checking',
      name: 'Intest',
      desc: '',
      args: [],
    );
  }

  /// `Searching`
  String get Insearch {
    return Intl.message(
      'Searching',
      name: 'Insearch',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get accomplish {
    return Intl.message(
      'Finish',
      name: 'accomplish',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Not Started`
  String get notstart {
    return Intl.message(
      'Not Started',
      name: 'notstart',
      desc: '',
      args: [],
    );
  }

  /// `To Search`
  String get startSearch {
    return Intl.message(
      'To Search',
      name: 'startSearch',
      desc: '',
      args: [],
    );
  }

  /// `current Value`
  String get currentValue {
    return Intl.message(
      'current Value',
      name: 'currentValue',
      desc: '',
      args: [],
    );
  }

  /// `Max Value`
  String get maxValue {
    return Intl.message(
      'Max Value',
      name: 'maxValue',
      desc: '',
      args: [],
    );
  }

  /// `Current orientation`
  String get currentOrientation {
    return Intl.message(
      'Current orientation',
      name: 'currentOrientation',
      desc: '',
      args: [],
    );
  }

  /// `Static DNS has the highest priority, VPN DNS follows it and LTE DNS has the lowest priority. If you want to restore the VPN/LTE DNS, please clear the two DNS configuration and submit`
  String get dnsStatic {
    return Intl.message(
      'Static DNS has the highest priority, VPN DNS follows it and LTE DNS has the lowest priority. If you want to restore the VPN/LTE DNS, please clear the two DNS configuration and submit',
      name: 'dnsStatic',
      desc: '',
      args: [],
    );
  }

  /// `Date to reboot`
  String get EnableScheduler {
    return Intl.message(
      'Reboot date',
      name: 'EnableScheduler',
      desc: '',
      args: [],
    );
  }

  /// `Restart start time`
  String get DateReboot {
    return Intl.message(
      'Restart start time',
      name: 'DateReboot',
      desc: '',
      args: [],
    );
  }

  /// `Restart end time`
  String get TimeReboot {
    return Intl.message(
      'Restart end time',
      name: 'TimeReboot',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get Sun {
    return Intl.message(
      'Sun',
      name: 'Sun',
      desc: '',
      args: [],
    );
  }

  /// `mon`
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get Tue {
    return Intl.message(
      'Tue',
      name: 'Tue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get Wed {
    return Intl.message(
      'Wed',
      name: 'Wed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get Thu {
    return Intl.message(
      'Thu',
      name: 'Thu',
      desc: '',
      args: [],
    );
  }

  /// `fri`
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get Sat {
    return Intl.message(
      'Sat',
      name: 'Sat',
      desc: '',
      args: [],
    );
  }

  /// `No device is connected`
  String get NoDeviceConnected {
    return Intl.message(
      'No device is connected',
      name: 'NoDeviceConnected',
      desc: '',
      args: [],
    );
  }

  /// `Input detection server`
  String get detectionServer {
    return Intl.message(
      'Input detection server',
      name: 'detectionServer',
      desc: '',
      args: [],
    );
  }

  /// `The device will restart after submission. Do you want to continue?`
  String get isRestart {
    return Intl.message(
      'The device will restart after submission. Do you want to continue?',
      name: 'isRestart',
      desc: '',
      args: [],
    );
  }

   String get isReset {
    return Intl.message(
      'The device will reset after submission. Do you want to continue?',
      name: 'isReset',
      desc: '',
      args: [],
    );
  }

  /// `Account or password incorrect, remaining input attempts:`
  String get passError {
    return Intl.message(
      'Account or password incorrect, remaining input attempts:',
      name: 'passError',
      desc: '',
      args: [],
    );
  }

  /// `The device has been locked, it will be unlocked in `
  String get locked {
    return Intl.message(
      'The device has been locked, it will be unlocked in ',
      name: 'locked',
      desc: '',
      args: [],
    );
  }

  /// `s`
  String get unlock {
    return Intl.message(
      's',
      name: 'unlock',
      desc: '',
      args: [],
    );
  }

  /// `The account cannot be empty`
  String get accountEmpty {
    return Intl.message(
      'The account cannot be empty',
      name: 'accountEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The password cannot be empty`
  String get passwordEmpty {
    return Intl.message(
      'The password cannot be empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `account`
  String get account {
    return Intl.message(
      'account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the account number`
  String get accountEnter {
    return Intl.message(
      'Please enter the account number',
      name: 'accountEnter',
      desc: '',
      args: [],
    );
  }

  /// `Administrator Login`
  String get Administratorlogin {
    return Intl.message(
      'Administrator Login',
      name: 'Administratorlogin',
      desc: '',
      args: [],
    );
  }

  /// `Device connection timeout`
  String get timeout {
    return Intl.message(
      'Device connection timeout',
      name: 'timeout',
      desc: '',
      args: [],
    );
  }

  /// `Abort Search`
  String get stopSerch {
    return Intl.message(
      'Abort Search',
      name: 'stopSerch',
      desc: '',
      args: [],
    );
  }

  /// `change Password`
  String get EditPass {
    return Intl.message(
      'change Password',
      name: 'EditPass',
      desc: '',
      args: [],
    );
  }

  /// `The password must be a combination of 8 to 16 digits and characters.`
  String get PassRule {
    return Intl.message(
      'The password must be a combination of 8 to 16 digits and characters.',
      name: 'PassRule',
      desc: '',
      args: [],
    );
  }

  /// `The new password is different from the confirmed password`
  String get newOldError {
    return Intl.message(
      'The new password is different from the confirmed password',
      name: 'newOldError',
      desc: '',
      args: [],
    );
  }

  /// ` Confirm the password`
  String get confrimPassorld {
    return Intl.message(
      ' Confirm the password ',
      name: 'confrimPassorld',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassowld {
    return Intl.message(
      'New Password',
      name: 'newPassowld',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get ConfirmnewPassowld {
    return Intl.message(
      'Please enter a new password',
      name: 'ConfirmnewPassowld',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassowld {
    return Intl.message(
      'Old Password',
      name: 'oldPassowld',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a old password`
  String get ConfirmOldPassowld {
    return Intl.message(
      'Please enter a old password',
      name: 'ConfirmOldPassowld',
      desc: '',
      args: [],
    );
  }

  /// `Please set the login password`
  String get loginPassword {
    return Intl.message(
      'Please set the login password',
      name: 'loginPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change passwords periodically to improve security`
  String get improveSecurity {
    return Intl.message(
      'Change passwords periodically to improve security',
      name: 'improveSecurity',
      desc: '',
      args: [],
    );
  }

  /// `The restart date must be selected`
  String get mustSuccess {
    return Intl.message(
      'The restart date must be selected',
      name: 'mustSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Local`
  String get local {
    return Intl.message(
      'Local',
      name: 'local',
      desc: '',
      args: [],
    );
  }

  /// `Examine`
  String get examine {
    return Intl.message(
      'Examine',
      name: 'examine',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get noData {
    return Intl.message(
      'No Data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `ASCII characters of 8 to 63 characters`
  String get ASCII {
    return Intl.message(
      'ASCII characters of 8 to 63 characters',
      name: 'ASCII',
      desc: '',
      args: [],
    );
  }

  /// `Not Empty!`
  String get notEmpty {
    return Intl.message(
      'Not Empty!',
      name: 'notEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `1~32 ASCII Character`
  String get ascii32 {
    return Intl.message(
      '1~32 ASCII Character',
      name: 'ascii32',
      desc: '',
      args: [],
    );
  }

  /// `Restart...`
  String get restart {
    return Intl.message(
      'Restart...',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `Version Updating`
  String get versionUpdating {
    return Intl.message(
      'Version Updating',
      name: 'versionUpdating',
      desc: '',
      args: [],
    );
  }

  /// `privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get userAgreement {
    return Intl.message(
      'User Agreement',
      name: 'userAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Cache Cleared`
  String get CacheCleared {
    return Intl.message(
      'Cache Cleared',
      name: 'CacheCleared',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Service`
  String get subService {
    return Intl.message(
      'Subscription Service',
      name: 'subService',
      desc: '',
      args: [],
    );
  }

  /// `Parental Control`
  String get parentalControl {
    return Intl.message(
      'Parental Control',
      name: 'parentalControl',
      desc: '',
      args: [],
    );
  }

  /// `Game Booster`
  String get gameAcceleration {
    return Intl.message(
      'Game Booster',
      name: 'gameAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `Your Subscription`
  String get yourServiece {
    return Intl.message(
      'Your Subscription',
      name: 'yourServiece',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `E-Learning`
  String get aivideo {
    return Intl.message(
      'E-Learning',
      name: 'aivideo',
      desc: '',
      args: [],
    );
  }

  /// `d`
  String get date {
    return Intl.message(
      'd',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `h`
  String get hour {
    return Intl.message(
      'h',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `m`
  String get minute {
    return Intl.message(
      'm',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Connection Timeout`
  String get contimeout {
    return Intl.message(
      'Connection Timeout',
      name: 'contimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request Timeout`
  String get Reqtimeout {
    return Intl.message(
      'Request Timeout',
      name: 'Reqtimeout',
      desc: '',
      args: [],
    );
  }

  /// `Response Timeout`
  String get Restimeout {
    return Intl.message(
      'Response Timeout',
      name: 'Restimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request Cancellation`
  String get Reqcancellation {
    return Intl.message(
      'Request Cancellation',
      name: 'Reqcancellation',
      desc: '',
      args: [],
    );
  }

  /// `Network Anomaly`
  String get networkError {
    return Intl.message(
      'Network Anomaly',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `You can enjoy more services`
  String get Remote {
    return Intl.message(
      'You can enjoy more services',
      name: 'Remote',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Follower System`
  String get FollowerSystem {
    return Intl.message(
      'Follower System',
      name: 'FollowerSystem',
      desc: '',
      args: [],
    );
  }

  /// `Logout login failed, Please check the network!`
  String get checkNet {
    return Intl.message(
      'Logout login failed, Please check the network!',
      name: 'checkNet',
      desc: '',
      args: [],
    );
  }

  /// ` Please subscribe to plan`
  String get nogameAcceleration {
    return Intl.message(
      ' Please subscribe to plan',
      name: 'nogameAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `Please subscribe to plan`
  String get noaivideo {
    return Intl.message(
      'Please subscribe to plan',
      name: 'noaivideo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain the parent list`
  String get getParebtalError {
    return Intl.message(
      'Failed to obtain the parent list',
      name: 'getParebtalError',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get modification {
    return Intl.message(
      'Edit',
      name: 'modification',
      desc: '',
      args: [],
    );
  }

  /// ` Access Forbidden`
  String get access {
    return Intl.message(
      ' Access Forbidden',
      name: 'access',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Equipment`
  String get equipment {
    return Intl.message(
      'Equipment',
      name: 'equipment',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Workday`
  String get workday {
    return Intl.message(
      'Workday',
      name: 'workday',
      desc: '',
      args: [],
    );
  }

  /// `Bind Device`
  String get band {
    return Intl.message(
      'Bind Device',
      name: 'band',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message(
      'Good',
      name: 'good',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi Coverage`
  String get Environment {
    return Intl.message(
      'Wi-Fi Coverage',
      name: 'Environment',
      desc: '',
      args: [],
    );
  }

  /// `Used`
  String get used {
    return Intl.message(
      'Used',
      name: 'used',
      desc: '',
      args: [],
    );
  }

  /// `Traffic`
  String get traffic {
    return Intl.message(
      'Traffic',
      name: 'traffic',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get sets {
    return Intl.message(
      'Set',
      name: 'sets',
      desc: '',
      args: [],
    );
  }

  /// `Data Plan`
  String get trafficPackage {
    return Intl.message(
      'Data Plan',
      name: 'trafficPackage',
      desc: '',
      args: [],
    );
  }

  /// `Up`
  String get up {
    return Intl.message(
      'Up',
      name: 'up',
      desc: '',
      args: [],
    );
  }

  /// `Down`
  String get down {
    return Intl.message(
      'Down',
      name: 'down',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get device {
    return Intl.message(
      'Devices',
      name: 'device',
      desc: '',
      args: [],
    );
  }

  /// `Parental Control`
  String get parent {
    return Intl.message(
      'Parental Control',
      name: 'parent',
      desc: '',
      args: [],
    );
  }

  /// `Monitor`
  String get monitor {
    return Intl.message(
      'Monitor',
      name: 'monitor',
      desc: '',
      args: [],
    );
  }

  /// `Net Speed Test`
  String get netSpeed {
    return Intl.message(
      'Net Speed Test',
      name: 'netSpeed',
      desc: '',
      args: [],
    );
  }

  /// `E-Learning`
  String get online {
    return Intl.message(
      'E-Learning',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Game Booster`
  String get game {
    return Intl.message(
      'Game Booster',
      name: 'game',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get line {
    return Intl.message(
      'Online',
      name: 'line',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get more {
    return Intl.message(
      'View More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Network Config`
  String get NetworkConfig {
    return Intl.message(
      'Network Config',
      name: 'NetworkConfig',
      desc: '',
      args: [],
    );
  }

  /// `Select Internet access mode`
  String get interentMode {
    return Intl.message(
      'Select Internet access mode',
      name: 'interentMode',
      desc: '',
      args: [],
    );
  }

  /// `Device Login`
  String get Devicelogin {
    return Intl.message(
      'Device Login',
      name: 'Devicelogin',
      desc: '',
      args: [],
    );
  }

  /// `Automatic IP retrieval`
  String get autoip {
    return Intl.message(
      'Automatic IP retrieval',
      name: 'autoip',
      desc: '',
      args: [],
    );
  }

  /// `Automatic dial-up and IP acquisition`
  String get IPAcquisition {
    return Intl.message(
      'Automatic dial-up and IP acquisition',
      name: 'IPAcquisition',
      desc: '',
      args: [],
    );
  }

  /// `Manually configure IP address, subnet mask, gateway, and DNS`
  String get ManuallyIP {
    return Intl.message(
      'Manually configure IP address, subnet mask, gateway, and DNS',
      name: 'ManuallyIP',
      desc: '',
      args: [],
    );
  }

  /// `Next Step`
  String get Next {
    return Intl.message(
      'Next Step',
      name: 'Next',
      desc: '',
      args: [],
    );
  }

  /// `Previous Step`
  String get Previous {
    return Intl.message(
      'Previous Step',
      name: 'Previous',
      desc: '',
      args: [],
    );
  }

  /// `Preferred DNS server`
  String get DNSServer {
    return Intl.message(
      'Preferred DNS server',
      name: 'DNSServer',
      desc: '',
      args: [],
    );
  }

  /// `Preferred DNS server (optional)`
  String get DNS2Server {
    return Intl.message(
      'Preferred DNS server (optional)',
      name: 'DNS2Server',
      desc: '',
      args: [],
    );
  }

  /// `Use MAC address cloning`
  String get macAddress {
    return Intl.message(
      'Use MAC address cloning',
      name: 'macAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the content`
  String get pleaseEnter {
    return Intl.message(
      'Please enter the content',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  /// `Device Name`
  String get ModifyRemarks {
    return Intl.message(
      'Device Name',
      name: 'ModifyRemarks',
      desc: '',
      args: [],
    );
  }

  /// `Make sure the router is connected to the power supply and the WAN port is plugged in with an Ethernet cable`
  String get SureRouterConnected {
    return Intl.message(
      'Make sure the router is connected to the power supply and the WAN port is plugged in with an Ethernet cable',
      name: 'SureRouterConnected',
      desc: '',
      args: [],
    );
  }

  /// `Detection and Editing`
  String get DetectionAndEdit {
    return Intl.message(
      'Detection and Editing',
      name: 'DetectionAndEdit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Layout`
  String get EditUnit {
    return Intl.message(
      'Edit Layout',
      name: 'EditUnit',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi signal coverage map(for reference only)`
  String get Blueprint {
    return Intl.message(
      'Wi-Fi signal coverage map(for reference only)',
      name: 'Blueprint',
      desc: '',
      args: [],
    );
  }

  /// `Retest`
  String get RetestF {
    return Intl.message(
      'Retest',
      name: 'RetestF',
      desc: '',
      args: [],
    );
  }

  /// `Signal Coverage`
  String get TestSignal {
    return Intl.message(
      'Signal Coverage',
      name: 'TestSignal',
      desc: '',
      args: [],
    );
  }

  /// `Start Test`
  String get startTesting {
    return Intl.message(
      'Start Test',
      name: 'startTesting',
      desc: '',
      args: [],
    );
  }

  /// `Get the signal strength of the room`
  String get roomStrength {
    return Intl.message(
      'Get the signal strength of the room',
      name: 'roomStrength',
      desc: '',
      args: [],
    );
  }

  /// `Generate Overlay`
  String get GenerateOverlay {
    return Intl.message(
      'Generate Overlay',
      name: 'GenerateOverlay',
      desc: '',
      args: [],
    );
  }

  /// `Please drag the router to the corresponding position in the room, and then click Start detection to draw the signal coverage map`
  String get coverageMap {
    return Intl.message(
      'Please drag the router to the corresponding position in the room, and then click Start detection to draw the signal coverage map',
      name: 'coverageMap',
      desc: '',
      args: [],
    );
  }

  /// `Please move to the current room`
  String get moveCurrentRoom {
    return Intl.message(
      'Please move to the current room',
      name: 'moveCurrentRoom',
      desc: '',
      args: [],
    );
  }

  /// `deviceUnprovide`
  String get deviceUnprovide {
    return Intl.message(
      "Device not registered, please contact operator",
      name: 'deviceUnprovide',
      desc: '',
      args: [],
    );
  }

  // No data has been obtained yet
  String get noDataTips {
    return Intl.message(
      "No data has been obtained yet",
      name: 'noDataTips',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en"),
      Locale.fromSubtags(languageCode: 'en',countryCode: "US"),
      // Locale.fromSubtags(languageCode: 'sp'),
      // Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
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
