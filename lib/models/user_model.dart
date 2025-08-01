class UserModel {
  final String? uid;
  final String name;
  final int age;
  final double weight;
  final bool hasPCOD;
  final List<String> goals;
  final String email;
  final DateTime createdAt;

  UserModel({
    this.uid,
    required this.name,
    required this.age,
    required this.weight,
    required this.hasPCOD,
    required this.goals,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'weight': weight,
      'hasPCOD': hasPCOD,
      'goals': goals,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      hasPCOD: map['hasPCOD'] ?? false,
      goals: List<String>.from(map['goals'] ?? []),
      email: map['email'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    int? age,
    double? weight,
    bool? hasPCOD,
    List<String>? goals,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      hasPCOD: hasPCOD ?? this.hasPCOD,
      goals: goals ?? this.goals,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 