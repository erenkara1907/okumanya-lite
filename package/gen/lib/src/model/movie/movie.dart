// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()

/// This model will use X api response to create an instance of MovieModel
class Movie with EquatableMixin {
  /// Constructor to create an instance of Movie
  const Movie({
    required this.adult,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.backdropPath,
    this.posterPath,
  });

  /// [Movie.fromJson] method to convert json to Movie
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  /// [adult] is the adult content flag
  final bool adult;
  @JsonKey(name: 'backdrop_path')

  /// [backdropPath] is the backdrop image path
  final String? backdropPath;
  @JsonKey(name: 'genre_ids')

  /// [genreIds] is the list of genre ids
  final List<int> genreIds;

  /// [id] is the unique identifier of the movie
  final int id;
  @JsonKey(name: 'original_language')

  /// [originalLanguage] is the original language of the movie
  final String originalLanguage;
  @JsonKey(name: 'original_title')

  /// [originalTitle] is the original title of the movie
  final String originalTitle;

  /// [overview] is the overview of the movie
  final String overview;

  /// [popularity] is the popularity score of the movie
  final double popularity;
  @JsonKey(name: 'poster_path')

  /// [posterPath] is the poster image path
  final String? posterPath;
  @JsonKey(name: 'release_date')

  /// [releaseDate] is the release date of the movie
  final String releaseDate;

  /// [title] is the title of the movie
  final String title;

  /// [video] is the video flag
  final bool video;
  @JsonKey(name: 'vote_average')

  /// [voteAverage] is the average vote score of the movie
  final double voteAverage;
  @JsonKey(name: 'vote_count')

  /// [voteCount] is the total number of votes for the movie
  final int voteCount;

  /// [toJson] method to convert Movie to json
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  // Helper method to get full poster URL
  String? get fullPosterPath =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  // Helper method to get full backdrop URL
  String? get fullBackdropPath => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w500$backdropPath'
      : null;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
      ];
}
