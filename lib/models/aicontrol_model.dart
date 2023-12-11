class AICONTROL {
  String? userEmail;
  String? controlAi;
  String? userPassword;

  AICONTROL({this.userEmail, this.controlAi, this.userPassword});

  AICONTROL.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    controlAi = json['control_Ai'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['control_Ai'] = this.controlAi;
    data['userPassword'] = this.userPassword;
    return data;
  }
}
