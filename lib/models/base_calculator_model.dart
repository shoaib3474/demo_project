class BaseCalculatorModel {
  final double amount;
  final double rate;
  final double time;
  final String? timeType; // Optional
  final double? result1; // Optional - e.g., interest
  final double? result2; // Optional - e.g., total
  final double? result3; // Optional - e.g., total
  final double? result4; // Optional - e.g., total
  final List? table;

  BaseCalculatorModel({
    required this.amount,
    required this.rate,
    required this.time,
    this.timeType,
    this.result1,
    this.result2,
    this.result3,
    this.result4,
    this.table
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'rate': rate,
      'time': time,
      'timeType': timeType,
      'result1': result1,
      'result2': result2,
      'result3': result3,
      'result4': result4,
      'table':table
    };
  }

  factory BaseCalculatorModel.fromMap(Map<String, dynamic> map) {
    return BaseCalculatorModel(
      amount: map['amount'] ?? 0,
      rate: map['rate'] ?? 0,
      time: map['time'] ?? 0,
      timeType: map['timeType'],
      result1: map['result1'],
      result2: map['result2'],
      result3: map['result3'],
      result4: map['result4'],
      table: map['table']
    );
  }
}
