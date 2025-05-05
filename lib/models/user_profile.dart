class UserProfile {
  final String gender;
  final String name;
  final int age;
  final double height;
  final double weight;

  UserProfile({
    required this.gender,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}
