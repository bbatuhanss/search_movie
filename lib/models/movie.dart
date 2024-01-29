import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  @JsonKey(name: 'id')
  final int movieId;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'overview')
  final String? overview;

  @JsonKey(name: 'original_title')
  final String? originalTitle;

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  @JsonKey(name: 'popularity')
  final double? popularity;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'genres')
  final List? genresList;

  Movie(
      {this.title,
      this.posterPath,
      this.overview,
      this.originalTitle,
      this.backdropPath,
      this.popularity,
      this.voteAverage,
      this.genresList,
      required this.movieId});

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
