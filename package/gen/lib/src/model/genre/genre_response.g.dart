// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreResponse _$GenreResponseFromJson(Map<String, dynamic> json) =>
    GenreResponse(
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenreResponseToJson(GenreResponse instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };
