class SOLENOIDCONTROL {
  String? userEmail;
  String? controlSolenoid;
  String? userPassword;

  SOLENOIDCONTROL({this.userEmail, this.controlSolenoid, this.userPassword});

  SOLENOIDCONTROL.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    controlSolenoid = json['control_Solenoid'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['control_Solenoid'] = this.controlSolenoid;
    data['userPassword'] = this.userPassword;
    return data;
  }
}