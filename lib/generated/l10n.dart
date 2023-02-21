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

  /// `enter your password`
  String get passwordLabel {
    return Intl.message(
      'enter your password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// ` enter your password again`
  String get passwordAgain {
    return Intl.message(
      ' enter your password again',
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

  /// `Discovery equipment`
  String get DiscoveryEqu {
    return Intl.message(
      'Discovery equipment',
      name: 'DiscoveryEqu',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `connecting device`
  String get conDev {
    return Intl.message(
      'connecting device',
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

  /// `rescan`
  String get rescan {
    return Intl.message(
      'rescan',
      name: 'rescan',
      desc: '',
      args: [],
    );
  }

  /// `UntyingEqui`
  String get UntyingEqui {
    return Intl.message(
      'UntyingEqui',
      name: 'UntyingEqui',
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

  /// `Professional`
  String get majorSet {
    return Intl.message(
      'Professional',
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

  /// `system Information`
  String get systemInfo {
    return Intl.message(
      'system Information',
      name: 'systemInfo',
      desc: '',
      args: [],
    );
  }

  /// `version Information`
  String get versionInfo {
    return Intl.message(
      'version Information',
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

  /// `Ethernet Status`
  String get EthernetStatus {
    return Intl.message(
      'Ethernet Status',
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

  /// `NetWork`
  String get netSet {
    return Intl.message(
      'NetWork',
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

  /// `LAN Host Settings`
  String get lanHostSettings {
    return Intl.message(
      'LAN Host Settings',
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

  /// `clearCache`
  String get clearCache {
    return Intl.message(
      'clearCache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Net Topo`
  String get netTopo {
    return Intl.message(
      'Net Topo',
      name: 'netTopo',
      desc: '',
      args: [],
    );
  }

  /// `advanced Settings`
  String get advancedSet {
    return Intl.message(
      'advanced Settings',
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

  /// `Hide SSID broadcast`
  String get HideSSIDBroadcast {
    return Intl.message(
      'Hide SSID broadcast',
      name: 'HideSSIDBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `AP isolation`
  String get APIsolation {
    return Intl.message(
      'AP isolation',
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

  /// `WPA encryption`
  String get WPAEncry {
    return Intl.message(
      'WPA encryption',
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

  /// `error`
  String get error {
    return Intl.message(
      'error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `not Enable`
  String get notEnable {
    return Intl.message(
      'not Enable',
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

  /// `Visitor Network Index`
  String get NetworkIndex {
    return Intl.message(
      'Visitor Network Index',
      name: 'NetworkIndex',
      desc: '',
      args: [],
    );
  }

  /// `Allow Access to the Intranet`
  String get AllowAccess {
    return Intl.message(
      'Allow Access to the Intranet',
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

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `status`
  String get status {
    return Intl.message(
      'status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `connectMethod`
  String get connectMethod {
    return Intl.message(
      'connectMethod',
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

  /// `start IP Address`
  String get startIPAddress {
    return Intl.message(
      'start IP Address',
      name: 'startIPAddress',
      desc: '',
      args: [],
    );
  }

  /// `end IP Address`
  String get endIPAddress {
    return Intl.message(
      'end IP Address',
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

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
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

  /// `connection Mode`
  String get connectionMode {
    return Intl.message(
      'connection Mode',
      name: 'connectionMode',
      desc: '',
      args: [],
    );
  }

  /// `link Status`
  String get linkStatus {
    return Intl.message(
      'link Status',
      name: 'linkStatus',
      desc: '',
      args: [],
    );
  }

  /// `connect Status`
  String get connectStatus {
    return Intl.message(
      'connect Status',
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

  /// `priority`
  String get priority {
    return Intl.message(
      'priority',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `current Deive`
  String get currentDeive {
    return Intl.message(
      'current Deive',
      name: 'currentDeive',
      desc: '',
      args: [],
    );
  }

  /// `log out`
  String get logOut {
    return Intl.message(
      'log out',
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

  /// `AES(Recommend)`
  String get aesRecommend {
    return Intl.message(
      'AES(Recommend)',
      name: 'aesRecommend',
      desc: '',
      args: [],
    );
  }

  /// `None(not recommended)`
  String get emptyNORecommend {
    return Intl.message(
      'None(not recommended)',
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

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
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

  /// `ununited`
  String get ununited {
    return Intl.message(
      'ununited',
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

  /// `staticIP`
  String get staticIP {
    return Intl.message(
      'staticIP',
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

  /// `Enable Reboot Scheduler`
  String get EnableRebootScheduler {
    return Intl.message(
      'Enable Reboot Scheduler',
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

  /// `Please click Reboot to reboot device`
  String get clickReboot {
    return Intl.message(
      'Please click Reboot to reboot device',
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

  /// `Please click Factory Reset to restore device to its factory settings`
  String get clickFactory {
    return Intl.message(
      'Please click Factory Reset to restore device to its factory settings',
      name: 'clickFactory',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to unblock the current device`
  String get unblockdevice {
    return Intl.message(
      'Confirm to unblock the current device',
      name: 'unblockdevice',
      desc: '',
      args: [],
    );
  }

  /// `binding?`
  String get binding {
    return Intl.message(
      'binding?',
      name: 'binding',
      desc: '',
      args: [],
    );
  }

  /// `hint`
  String get hint {
    return Intl.message(
      'hint',
      name: 'hint',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
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

  /// `Not set`
  String get Notset {
    return Intl.message(
      'Not set',
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

  /// `max Value`
  String get maxValue {
    return Intl.message(
      'max Value',
      name: 'maxValue',
      desc: '',
      args: [],
    );
  }

  /// `current Orientation`
  String get currentOrientation {
    return Intl.message(
      'current Orientation',
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

  /// `Enable Reboot Scheduler`
  String get EnableScheduler {
    return Intl.message(
      'Enable Reboot Scheduler',
      name: 'EnableScheduler',
      desc: '',
      args: [],
    );
  }

  /// `Date to Reboot`
  String get DateReboot {
    return Intl.message(
      'Date to Reboot',
      name: 'DateReboot',
      desc: '',
      args: [],
    );
  }

  /// `Time of Day to Reboot`
  String get TimeReboot {
    return Intl.message(
      'Time of Day to Reboot',
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
      'mon',
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
      'fri',
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
  String get isGoOn {
    return Intl.message(
      'The device will restart after submission. Do you want to continue?',
      name: 'isGoOn',
      desc: '',
      args: [],
    );
  }

  /// `Password error, number of attempts left:`
  String get passError {
    return Intl.message(
      'Password error, number of attempts left:',
      name: 'passError',
      desc: '',
      args: [],
    );
  }

  /// `locked`
  String get locked {
    return Intl.message(
      'locked',
      name: 'locked',
      desc: '',
      args: [],
    );
  }

  /// `S unlock`
  String get unlock {
    return Intl.message(
      'S unlock',
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

  /// `Administrator login`
  String get Administratorlogin {
    return Intl.message(
      'Administrator login',
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

  /// `Abort search`
  String get stopSerch {
    return Intl.message(
      'Abort search',
      name: 'stopSerch',
      desc: '',
      args: [],
    );
  }

  /// `change password`
  String get EditPass {
    return Intl.message(
      'change password',
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

  /// ` confirm the password.`
  String get confrimPassorld {
    return Intl.message(
      ' confirm the password.',
      name: 'confrimPassorld',
      desc: '',
      args: [],
    );
  }

  /// `new password`
  String get newPassowld {
    return Intl.message(
      'new password',
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

  /// `old password`
  String get oldPassowld {
    return Intl.message(
      'old password',
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

  /// `local`
  String get local {
    return Intl.message(
      'local',
      name: 'local',
      desc: '',
      args: [],
    );
  }

  /// `examine`
  String get examine {
    return Intl.message(
      'examine',
      name: 'examine',
      desc: '',
      args: [],
    );
  }

  /// `no Data`
  String get noData {
    return Intl.message(
      'no Data',
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

  /// `not Empty!`
  String get notEmpty {
    return Intl.message(
      'not Empty!',
      name: 'notEmpty',
      desc: '',
      args: [],
    );
  }

  /// `enter`
  String get enter {
    return Intl.message(
      'enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `1~32 ASCII character`
  String get ascii32 {
    return Intl.message(
      '1~32 ASCII character',
      name: 'ascii32',
      desc: '',
      args: [],
    );
  }

  /// `restart...`
  String get restart {
    return Intl.message(
      'restart...',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `version Updating`
  String get versionUpdating {
    return Intl.message(
      'version Updating',
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

  /// `user Agreement`
  String get userAgreement {
    return Intl.message(
      'user Agreement',
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

  /// `subscription service`
  String get subService {
    return Intl.message(
      'subscription service',
      name: 'subService',
      desc: '',
      args: [],
    );
  }

  /// `parental control`
  String get parentalControl {
    return Intl.message(
      'parental control',
      name: 'parentalControl',
      desc: '',
      args: [],
    );
  }

  /// `game acceleration`
  String get gameAcceleration {
    return Intl.message(
      'game acceleration',
      name: 'gameAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `your subscription`
  String get yourServiece {
    return Intl.message(
      'your subscription',
      name: 'yourServiece',
      desc: '',
      args: [],
    );
  }

  /// `options`
  String get options {
    return Intl.message(
      'options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `AI video`
  String get aivideo {
    return Intl.message(
      'AI video',
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

  /// `type`
  String get type {
    return Intl.message(
      'type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `connection timeout`
  String get contimeout {
    return Intl.message(
      'connection timeout',
      name: 'contimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request timeout`
  String get Reqtimeout {
    return Intl.message(
      'Request timeout',
      name: 'Reqtimeout',
      desc: '',
      args: [],
    );
  }

  /// `Response timeout`
  String get Restimeout {
    return Intl.message(
      'Response timeout',
      name: 'Restimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request cancellation`
  String get Reqcancellation {
    return Intl.message(
      'Request cancellation',
      name: 'Reqcancellation',
      desc: '',
      args: [],
    );
  }

  /// `network anomaly`
  String get networkError {
    return Intl.message(
      'network anomaly',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Remote control can be realized after login`
  String get Remote {
    return Intl.message(
      'Remote control can be realized after login',
      name: 'Remote',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Follower system`
  String get FollowerSystem {
    return Intl.message(
      'Follower system',
      name: 'FollowerSystem',
      desc: '',
      args: [],
    );
  }

  /// `Logout login failed, please check the network!`
  String get checkNet {
    return Intl.message(
      'Logout login failed, please check the network!',
      name: 'checkNet',
      desc: '',
      args: [],
    );
  }

  /// ` Do not subscribe to game acceleration yet, please go to subscription service to subscribe`
  String get nogameAcceleration {
    return Intl.message(
      ' Do not subscribe to game acceleration yet, please go to subscription service to subscribe',
      name: 'nogameAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `Do not subscribe to AI videos yet, please go to the subscription service to subscribe`
  String get noaivideo {
    return Intl.message(
      'Do not subscribe to AI videos yet, please go to the subscription service to subscribe',
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

  /// `edit`
  String get modification {
    return Intl.message(
      'edit',
      name: 'modification',
      desc: '',
      args: [],
    );
  }

  /// ` access forbidden`
  String get access {
    return Intl.message(
      ' access forbidden',
      name: 'access',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `equipment`
  String get equipment {
    return Intl.message(
      'equipment',
      name: 'equipment',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `workday`
  String get workday {
    return Intl.message(
      'workday',
      name: 'workday',
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
