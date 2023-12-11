class TIMECONTROL {
  String? userEmail;
  String? userPassword;
  String? controlDateOn;
  String? controlTimeOn;
  String? controlDateOFF;
  String? controlTimeOFF;

  TIMECONTROL(
      {this.userEmail,
      this.userPassword,
      this.controlDateOn,
      this.controlTimeOn,
      this.controlDateOFF,
      this.controlTimeOFF});

  TIMECONTROL.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    userPassword = json['userPassword'];
    controlDateOn = json['control_Date_On'];
    controlTimeOn = json['control_Time_On'];
    controlDateOFF = json['control_Date_OFF'];
    controlTimeOFF = json['control_Time_OFF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['userPassword'] = this.userPassword;
    data['control_Date_On'] = this.controlDateOn;
    data['control_Time_On'] = this.controlTimeOn;
    data['control_Date_OFF'] = this.controlDateOFF;
    data['control_Time_OFF'] = this.controlTimeOFF;
    return data;
  }
}