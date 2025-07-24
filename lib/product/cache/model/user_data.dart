import 'package:edumind_intro_app/product/widget/dropdown/model/school_grade.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart'; // Generated file

@HiveType(typeId: 0)
class UserData extends Equatable {
  const UserData({
    required this.id,
    required this.nickName,
    required this.originalNickName,
    required this.schoolName,
    required this.city,
    required this.grade,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      nickName: json['nickName'] as String,
      originalNickName: json['originalNickName'] as String,
      schoolName: json['schoolName'] as String,
      city: TurkishCity.fromJson(json['city'] as Map<String, dynamic>),
      grade: SchoolGrade.fromJson(json['grade'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nickName;

  @HiveField(2)
  final String originalNickName;

  @HiveField(3)
  final String schoolName;

  @HiveField(4)
  final TurkishCity city;

  @HiveField(5)
  final SchoolGrade grade;

  @HiveField(6)
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, nickName, originalNickName, schoolName, city, grade, createdAt];

  UserData copyWith({
    String? id,
    String? nickName,
    String? originalNickName,
    String? schoolName,
    TurkishCity? city,
    SchoolGrade? grade,
    DateTime? createdAt,
  }) {
    return UserData(
      id: id ?? this.id,
      nickName: nickName ?? this.nickName,
      originalNickName: originalNickName ?? this.originalNickName,
      schoolName: schoolName ?? this.schoolName,
      city: city ?? this.city,
      grade: grade ?? this.grade,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts the UserData instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickName': nickName,
      'originalNickName': originalNickName,
      'schoolName': schoolName,
      'city': city.toJson(),
      'grade': grade.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserData{id: $id, nickName: $nickName, originalNickName: $originalNickName, schoolName: $schoolName, city: ${city.name}, grade: ${grade.name}, createdAt: $createdAt}';
  }
}
