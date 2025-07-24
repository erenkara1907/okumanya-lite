// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:gen/src/model/genre/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre_response.g.dart';

@JsonSerializable()

/// This model will use X api response to create an instance of GenreModel
class GenreResponse with EquatableMixin {
  /// Constructor to create an instance of Genre
  const GenreResponse({
    required this.genres,
  });

  /// [GenreResponse.fromJson] method to convert json to Genre
  factory GenreResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseFromJson(json);

  /// [genres] is the list of genres
  final List<Genre> genres;

  /// [toJson] method to convert GenreResponse to json
  Map<String, dynamic> toJson() => _$GenreResponseToJson(this);
  @override
  List<Object?> get props => throw UnimplementedError();
}
