// TurkishCity Hive adapter
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'turkish_city.g.dart'; // Generated file

@HiveType(typeId: 1)

/// Represents a Turkish city with an ID and name.
class TurkishCity extends Equatable {
  /// Creates a [TurkishCity] instance with the given [id] and [name].
  const TurkishCity({
    required this.id,
    required this.name,
  });

  /// Creates a [TurkishCity] instance from a JSON map.
  factory TurkishCity.fromJson(Map<String, dynamic> json) => TurkishCity(
        id: json['id'] as String,
        name: json['name'] as String,
      );
  @HiveField(0)

  /// The unique identifier for the city.
  final String id;

  @HiveField(1)

  /// The name of the city.
  final String name;

  @override
  List<Object?> get props => [id, name];

  /// Creates a copy of this [TurkishCity] with the given fields replaced by new values.
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
