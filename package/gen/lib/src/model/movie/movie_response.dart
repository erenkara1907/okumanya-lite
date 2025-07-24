// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:gen/src/model/movie/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_response.g.dart';

@JsonSerializable()

/// This model will use X api response to create an instance of MovieResponse
class MovieResponse with EquatableMixin {
  /// Constructor to create an instance of MovieResponse
  const MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  /// [MovieResponse.fromJson] method to convert json to MovieResponse
  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  /// [page] is the current page number
  final int page;

  /// [results] is the list of movies
  final List<Movie> results;
  @JsonKey(name: 'total_pages')

  /// [totalPages] is the total number of pages
  final int totalPages;
  @JsonKey(name: 'total_results')

  /// [totalResults] is the total number of results
  final int totalResults;

  /// [toJson] method to convert MovieResponse to json
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
  @override
  List<Object?> get props => [
        page,
        results,
        totalPages,
        totalResults,
      ];
}
