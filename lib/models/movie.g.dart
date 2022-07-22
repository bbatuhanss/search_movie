// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    title: json['title'] as String?,
    posterPath: json['poster_path'] as String?,
    overview: json['overview'] as String?,
    originalTitle: json['original_title'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    popularity: (json['popularity'] as num?)?.toDouble(),
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    genresList: json['genres'] as List<dynamic>?,
    movieId: json['id'] as int,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.movieId,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'overview': instance.overview,
      'original_title': instance.originalTitle,
      'backdrop_path': instance.backdropPath,
      'popularity': instance.popularity,
      'vote_average': instance.voteAverage,
      'genres': instance.genresList,
    };
