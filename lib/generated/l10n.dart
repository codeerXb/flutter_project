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

  /// `UL Velocity`
  String get ULVelocity {
    return Intl.message(
      'UL Velocity',
      name: 'ULVelocity',
      desc: '',
      args: [],
    );
  }

  /// `DL Velocity`
  String get DLVelocity {
    return Intl.message(
      'DL Velocity',
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

  /// `not log in`
  String get noLogin {
    return Intl.message(
      'not log in',
      name: 'noLogin',
      desc: '',
      args: [],
    );
  }

  /// `time Online`
  String get timeOnline {
    return Intl.message(
      'time Online',
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
  String get PackageCycle {
    return Intl.message(
      'Package Cycle',
      name: 'PackageCycle',
      desc: '',
      args: [],
    );
  }

  /// `Total Package Quantity`
  String get TotalPackageQuantity {
    return Intl.message(
      'Total Package Quantity',
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

  /// `set`
  String get set {
    return Intl.message(
      'set',
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

  /// `Used Flow`
  String get UsedFlow {
    return Intl.message(
      'Used Flow',
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

  /// `In self test`
  String get Intest {
    return Intl.message(
      'In self test',
      name: 'Intest',
      desc: '',
      args: [],
    );
  }

  /// `In search`
  String get Insearch {
    return Intl.message(
      'In search',
      name: 'Insearch',
      desc: '',
      args: [],
    );
  }

  /// `accomplish`
  String get accomplish {
    return Intl.message(
      'accomplish',
      name: 'accomplish',
      desc: '',
      args: [],
    );
  }

  /// `reset`
  String get reset {
    return Intl.message(
      'reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `not start`
  String get notstart {
    return Intl.message(
      'not start',
      name: 'notstart',
      desc: '',
      args: [],
    );
  }

  /// `start Search`
  String get startSearch {
    return Intl.message(
      'start Search',
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
