class BaseCalculatorModel {
  double principal;
  double rate;
  double time;
  String timeType;

  BaseCalculatorModel({
    required this.principal,
    required this.rate,
    required this.time,
    required this.timeType,
  });

  double get interest {
    double years = timeType == 'Yearly' ? time : time / 12;
    return (principal * rate * years) / 100;
  }

  double get total => principal + interest;

  Map<String, dynamic> toJson() => {
    'principal': principal,
    'rate': rate,
    'time': time,
    'timeType': timeType,
  };

  factory BaseCalculatorModel.fromJson(Map<String, dynamic> json) {
    return BaseCalculatorModel(
      principal: json['principal'],
      rate: json['rate'],
      time: json['time'],
      timeType: json['timeType'],
    );
  }
}
