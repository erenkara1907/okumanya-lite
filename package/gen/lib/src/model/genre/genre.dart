import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()

/// This model will use X api response to create an instance of GenreModel
class Genre with EquatableMixin {
  /// Constructor to create an instance of Genre
  const Genre({
    required this.id,
    required this.name,
  });

  /// [Genre.fromJson] method to convert json to Genre
  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  /// [id] is the unique identifier of the genre
  final int id;

  /// [name] is the name of the genre
  final String name;

  /// [toJson] method to convert Genre to json
  Map<String, dynamic> toJson() => _$GenreToJson(this);
  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
