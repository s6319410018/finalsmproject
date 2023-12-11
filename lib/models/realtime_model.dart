class REALTIME {
  String? message;
  int? realtimeSolenoid;
  int? realtimeAI;
  int? realtimeTime;
  double? realtimeFlowrate;
  double? realtimePressure;
  String? userName;
  String? userAddress;
  String? userPhone;
  String? userEmail;
  int? userProductID;
  double? productDetailsMonthWaterUse;
  double? productDetailsDayWaterUse;
  int? alert;

  REALTIME(
      {this.message,
      this.realtimeSolenoid,
      this.realtimeAI,
      this.realtimeTime,
      this.realtimeFlowrate,
      this.realtimePressure,
      this.userName,
      this.userAddress,
      this.userPhone,
      this.userEmail,
      this.userProductID,
      this.productDetailsMonthWaterUse,
      this.productDetailsDayWaterUse,
      this.alert});

  REALTIME.fromJson(Map<String, dynamic> json) {
    message = json['message'] as String?;
    realtimeSolenoid = json['realtime_Solenoid']?.toInt();
    realtimeAI = json['realtime_AI']?.toInt();
    realtimeTime = json['realtime_Time']?.toInt();
    realtimeFlowrate = json['realtime_Flowrate']?.toDouble();
    realtimePressure = json['realtime_Pressure']?.toDouble();
    userName = json['user_Name'] as String?;
    userAddress = json['user_Address'] as String?;
    userPhone = json['user_Phone'] as String?;
    userEmail = json['user_Email'] as String?;
    userProductID = json['user_Product_ID']?.toInt();
    productDetailsMonthWaterUse =
        json['Product_Details_Month_Water_Use']?.toDouble();
    productDetailsDayWaterUse =
        json['Product_Details_Day_Water_Use']?.toDouble();
    alert = json['alert']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['realtime_Solenoid'] = realtimeSolenoid;
    data['realtime_AI'] = realtimeAI;
    data['realtime_Time'] = realtimeTime;
    data['realtime_Flowrate'] = realtimeFlowrate;
    data['realtime_Pressure'] = realtimePressure;
    data['user_Name'] = userName;
    data['user_Address'] = userAddress;
    data['user_Phone'] = userPhone;
    data['user_Email'] = userEmail;
    data['user_Product_ID'] = userProductID;
    data['Product_Details_Month_Water_Use'] = productDetailsMonthWaterUse;
    data['Product_Details_Day_Water_Use'] = productDetailsDayWaterUse;
    data['alert'] = this.alert;
    return data;
  }
}
