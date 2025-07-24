import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'school_grade.g.dart'; // Generated file

@HiveType(typeId: 2)

/// Represents a school grade with an ID, name, and level.
class SchoolGrade extends Equatable {
  /// Creates a [SchoolGrade] instance with the given [id], [name], and [level].
  const SchoolGrade({
    required this.id,
    required this.name,
    required this.level,
  });

  /// Creates a [SchoolGrade] instance from a JSON map.
  factory SchoolGrade.fromJson(Map<String, dynamic> json) => SchoolGrade(
        id: json['id'] as String,
        name: json['name'] as String,
        level: json['level'] as int,
      );
  @HiveField(0)

  /// The unique identifier for the school grade.
  final String id;

  @HiveField(1)

  /// The name of the school grade.
  final String name;

  @HiveField(2)

  /// The level of the school grade, typically indicating the educational stage.
  final int level;

  @override
  List<Object?> get props => [id, name, level];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'level': level};
}
