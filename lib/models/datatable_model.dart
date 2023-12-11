class DATATABLE {
  String? message;
  int? productDetailsMonthId;
  double? productDetailsMonthFlowrate;
  double? productDetailsMonthPressure;
  double? productDetailsMonthWaterUse;
  double? productDetailsDayWaterUse;
  int? productDetailsResultSolenoid;
  int? productDetailsResultTime;
  int? productDetailsResultAi;
  String? date;
  String? time;
  int? productKey;

  DATATABLE(
      {this.message,
      this.productDetailsMonthId,
      this.productDetailsMonthFlowrate,
      this.productDetailsMonthPressure,
      this.productDetailsMonthWaterUse,
      this.productDetailsDayWaterUse,
      this.productDetailsResultSolenoid,
      this.productDetailsResultTime,
      this.productDetailsResultAi,
      this.date,
      this.time,
      this.productKey});

  DATATABLE.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    productDetailsMonthId = json['Product_Details_Month_Id'];
    productDetailsMonthFlowrate =
        json['Product_Details_Month_Flowrate']?.toDouble();
    productDetailsMonthPressure =
        json['Product_Details_Month_Pressure']?.toDouble();
    productDetailsMonthWaterUse =
        json['Product_Details_Month_Water_Use']?.toDouble();
    productDetailsDayWaterUse =
        json['Product_Details_Day_Water_Use']?.toDouble();
    productDetailsResultSolenoid =
        json['Product_Details_Result_Solenoid']?.toInt();
    productDetailsResultTime = json['Product_Details_Result_Time']?.toInt();
    productDetailsResultAi = json['Product_Details_Result_Ai']?.toInt();
    date = json['date'];
    time = json['time'];
    productKey = json['product_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['Product_Details_Month_Id'] = this.productDetailsMonthId;
    data['Product_Details_Month_Flowrate'] = this.productDetailsMonthFlowrate;
    data['Product_Details_Month_Pressure'] = this.productDetailsMonthPressure;
    data['Product_Details_Month_Water_Use'] = this.productDetailsMonthWaterUse;
    data['Product_Details_Day_Water_Use'] = this.productDetailsDayWaterUse;
    data['Product_Details_Result_Solenoid'] = this.productDetailsResultSolenoid;
    data['Product_Details_Result_Time'] = this.productDetailsResultTime;
    data['Product_Details_Result_Ai'] = this.productDetailsResultAi;
    data['date'] = this.date;
    data['time'] = this.time;
    data['product_key'] = this.productKey;
    return data;
  }
}
