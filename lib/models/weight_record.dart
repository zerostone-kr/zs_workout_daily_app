class WeightRecord {
  final DateTime date;
  final double weight;

  WeightRecord({required this.date, required this.weight});

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
    };
  }

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      date: DateTime.parse(json['date']),
      weight: json['weight'],
    );
  }
}
