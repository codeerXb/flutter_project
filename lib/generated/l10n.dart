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

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Cpe management platform`
  String get cpeManagementPlatform {
    return Intl.message(
      'Cpe management platform',
      name: 'cpeManagementPlatform',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mobile phone nubmer`
  String get phoneLabel {
    return Intl.message(
      'Enter your mobile phone nubmer',
      name: 'phoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `The phone number is wrong`
  String get phoneError {
    return Intl.message(
      'The phone number is wrong',
      name: 'phoneError',
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

  /// `Verification code Error`
  String get verficationCodeError {
    return Intl.message(
      'Verification code Error',
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

  /// `login Successfully`
  String get loginSuccess {
    return Intl.message(
      'login Successfully',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Discovery Equipment`
  String get DiscoveryEqu {
    return Intl.message(
      'Discovery Equipment',
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

  /// `Connecting Device`
  String get conDev {
    return Intl.message(
      'Connecting Device',
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

  /// `Clear Cache`
  String get clearCache {
    return Intl.message(
      'Clear Cache',
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

  /// `Not Enable`
  String get notEnable {
    return Intl.message(
      'Not Enable',
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

  /// `Current Deive`
  String get currentDeive {
    return Intl.message(
      'Current Deive',
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

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
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
      'Hint',
      name: 'hint',
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

  /// `Static dNS has the highest priority, VPN DNS follows it and LTE DNS has the lowest priority. If you want to restore the VPN/LTE DNS, please clear the two DNS configuration and submit`
  String get dnsStatic {
    return Intl.message(
      'Static dNS has the highest priority, VPN DNS follows it and LTE DNS has the lowest priority. If you want to restore the VPN/LTE DNS, please clear the two DNS configuration and submit',
      name: 'dnsStatic',
      desc: '',
      args: [],
    );
  }

  /// `Enable reboot scheduler`
  String get EnableScheduler {
    return Intl.message(
      'Enable reboot scheduler',
      name: 'EnableScheduler',
      desc: '',
      args: [],
    );
  }

  /// `Date to reboot`
  String get DateReboot {
    return Intl.message(
      'Date to reboot',
      name: 'DateReboot',
      desc: '',
      args: [],
    );
  }

  /// `Time of day to reboot`
  String get TimeReboot {
    return Intl.message(
      'Time of day to reboot',
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

  /// `S Unlock`
  String get unlock {
    return Intl.message(
      'S Unlock',
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

  /// ` Confirm the password.`
  String get confrimPassorld {
    return Intl.message(
      ' Confirm the password.',
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

  /// `AI video`
  String get aivideo {
    return Intl.message(
      'AI video',
      name: 'aivideo',
      desc: '',
      args: [],
    );
  }

  /// `D`
  String get date {
    return Intl.message(
      'D',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get hour {
    return Intl.message(
      'H',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get minute {
    return Intl.message(
      'M',
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

  /// ` Do not subscribe to game acceleration yet, Please go to subscription service to subscribe`
  String get nogameAcceleration {
    return Intl.message(
      ' Do not subscribe to game acceleration yet, Please go to subscription service to subscribe',
      name: 'nogameAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `Do not subscribe to AI Videos tet, Please go to the subscription service to subscribe`
  String get noaivideo {
    return Intl.message(
      'Do not subscribe to AI Videos tet, Please go to the subscription service to subscribe',
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

  /// `Binding Device`
  String get band {
    return Intl.message(
      'Binding Device',
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

  /// `Environment`
  String get Environment {
    return Intl.message(
      'Environment',
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

  /// `Traffic Package`
  String get trafficPackage {
    return Intl.message(
      'Traffic Package',
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

  /// `Parent Control`
  String get parent {
    return Intl.message(
      'Parent Control',
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

  /// `Online Course`
  String get online {
    return Intl.message(
      'Online Course',
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
