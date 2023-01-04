class RadioGData {
  String? lteNetSelectMode;
  String? lteModeGet;
  String? lteOnOff;
  String? systemCurrentPlatform;
  String? lteMainStatusGet;
  String? lteDlmcs;
  String? lteUlmcs;
  String? lteDlEarfcnGet;
  String? lteDlFrequency;
  String? lteUlFrequency;
  String? lteBandGet;
  String? lteBandwidthGet;
  String? lteRsrp0;
  String? lteRsrp1;
  String? lteRssi;
  String? lteRsrq;
  String? lteSinr;
  String? lteCinr0;
  String? lteCinr1;
  String? lteTxpower;
  String? ltePci;
  String? lteCellidGet;
  String? lteMccGet;
  String? lteMncGet;
  String? lteDlEarfcnGet5g;
  String? lteDlFrequency5g;
  String? lteUlFrequency5g;
  String? lteBandGet5g;
  String? lteBandwidthGet5g;
  String? lteRsrp05g;
  String? lteRsrp15g;
  String? lteRsrq5g;
  String? lteSinr5g;
  String? ltePci5g;
  String? lteCellidGet5g;
  String? lteMccGet5g;
  String? lteMncGet5g;

  RadioGData(
      {this.lteNetSelectMode,
      this.lteModeGet,
      this.lteOnOff,
      this.systemCurrentPlatform,
      this.lteMainStatusGet,
      this.lteDlmcs,
      this.lteUlmcs,
      this.lteDlEarfcnGet,
      this.lteDlFrequency,
      this.lteUlFrequency,
      this.lteBandGet,
      this.lteBandwidthGet,
      this.lteRsrp0,
      this.lteRsrp1,
      this.lteRssi,
      this.lteRsrq,
      this.lteSinr,
      this.lteCinr0,
      this.lteCinr1,
      this.lteTxpower,
      this.ltePci,
      this.lteCellidGet,
      this.lteMccGet,
      this.lteMncGet,
      this.lteDlEarfcnGet5g,
      this.lteDlFrequency5g,
      this.lteUlFrequency5g,
      this.lteBandGet5g,
      this.lteBandwidthGet5g,
      this.lteRsrp05g,
      this.lteRsrp15g,
      this.lteRsrq5g,
      this.lteSinr5g,
      this.ltePci5g,
      this.lteCellidGet5g,
      this.lteMccGet5g,
      this.lteMncGet5g});

  RadioGData.fromJson(Map<String, dynamic> json) {
    lteNetSelectMode = json['lteNetSelectMode'];
    lteModeGet = json['lteModeGet'];
    lteOnOff = json['lteOnOff'];
    systemCurrentPlatform = json['systemCurrentPlatform'];
    lteMainStatusGet = json['lteMainStatusGet'];
    lteDlmcs = json['lteDlmcs'];
    lteUlmcs = json['lteUlmcs'];
    lteDlEarfcnGet = json['lteDlEarfcnGet'];
    lteDlFrequency = json['lteDlFrequency'];
    lteUlFrequency = json['lteUlFrequency'];
    lteBandGet = json['lteBandGet'];
    lteBandwidthGet = json['lteBandwidthGet'];
    lteRsrp0 = json['lteRsrp0'];
    lteRsrp1 = json['lteRsrp1'];
    lteRssi = json['lteRssi'];
    lteRsrq = json['lteRsrq'];
    lteSinr = json['lteSinr'];
    lteCinr0 = json['lteCinr0'];
    lteCinr1 = json['lteCinr1'];
    lteTxpower = json['lteTxpower'];
    ltePci = json['ltePci'];
    lteCellidGet = json['lteCellidGet'];
    lteMccGet = json['lteMccGet'];
    lteMncGet = json['lteMncGet'];
    lteDlEarfcnGet5g = json['lteDlEarfcnGet_5g'];
    lteDlFrequency5g = json['lteDlFrequency_5g'];
    lteUlFrequency5g = json['lteUlFrequency_5g'];
    lteBandGet5g = json['lteBandGet_5g'];
    lteBandwidthGet5g = json['lteBandwidthGet_5g'];
    lteRsrp05g = json['lteRsrp0_5g'];
    lteRsrp15g = json['lteRsrp1_5g'];
    lteRsrq5g = json['lteRsrq_5g'];
    lteSinr5g = json['lteSinr_5g'];
    ltePci5g = json['ltePci_5g'];
    lteCellidGet5g = json['lteCellidGet_5g'];
    lteMccGet5g = json['lteMccGet_5g'];
    lteMncGet5g = json['lteMncGet_5g'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lteNetSelectMode'] = lteNetSelectMode;
    data['lteModeGet'] = lteModeGet;
    data['lteOnOff'] = lteOnOff;
    data['systemCurrentPlatform'] = systemCurrentPlatform;
    data['lteMainStatusGet'] = lteMainStatusGet;
    data['lteDlmcs'] = lteDlmcs;
    data['lteUlmcs'] = lteUlmcs;
    data['lteDlEarfcnGet'] = lteDlEarfcnGet;
    data['lteDlFrequency'] = lteDlFrequency;
    data['lteUlFrequency'] = lteUlFrequency;
    data['lteBandGet'] = lteBandGet;
    data['lteBandwidthGet'] = lteBandwidthGet;
    data['lteRsrp0'] = lteRsrp0;
    data['lteRsrp1'] = lteRsrp1;
    data['lteRssi'] = lteRssi;
    data['lteRsrq'] = lteRsrq;
    data['lteSinr'] = lteSinr;
    data['lteCinr0'] = lteCinr0;
    data['lteCinr1'] = lteCinr1;
    data['lteTxpower'] = lteTxpower;
    data['ltePci'] = ltePci;
    data['lteCellidGet'] = lteCellidGet;
    data['lteMccGet'] = lteMccGet;
    data['lteMncGet'] = lteMncGet;
    data['lteDlEarfcnGet_5g'] = lteDlEarfcnGet5g;
    data['lteDlFrequency_5g'] = lteDlFrequency5g;
    data['lteUlFrequency_5g'] = lteUlFrequency5g;
    data['lteBandGet_5g'] = lteBandGet5g;
    data['lteBandwidthGet_5g'] = lteBandwidthGet5g;
    data['lteRsrp0_5g'] = lteRsrp05g;
    data['lteRsrp1_5g'] = lteRsrp15g;
    data['lteRsrq_5g'] = lteRsrq5g;
    data['lteSinr_5g'] = lteSinr5g;
    data['ltePci_5g'] = ltePci5g;
    data['lteCellidGet_5g'] = lteCellidGet5g;
    data['lteMccGet_5g'] = lteMccGet5g;
    data['lteMncGet_5g'] = lteMncGet5g;
    return data;
  }
}
