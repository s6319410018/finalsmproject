class USER {
  String? userName;
  String? userAddress;
  String? userPhone;
  String? userPassword;
  String? userProductId;
  String? userEmail;

  USER({
    this.userName,
    this.userAddress,
    this.userPhone,
    this.userPassword,
    this.userProductId,
    this.userEmail,
  });

  USER.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userAddress = json['userAddress'];
    userPhone = json['userPhone'];
    userPassword = json['userPassword'];
    userProductId = json['userProductId'];
    userEmail = json['userEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['userAddress'] = this.userAddress;
    data['userPhone'] = this.userPhone;
    data['userPassword'] = this.userPassword;
    data['userProductId'] = this.userProductId;
    data['userEmail'] = this.userEmail;
    return data;
  }
}
