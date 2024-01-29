import 'dart:convert';
import '../models/movie.dart';
import 'api.dart';

class MovieService {
  MovieService._internal();

  static final MovieService _instance = MovieService._internal();

  factory MovieService() {
    return _instance;
  }

  Future<List<Movie>> getSearchMovie(String query, int pageNumber) async {
    final response = await get(
        "/search/movie?api_key=35ef0461fc4557cf1d256d3335ed7545&query=" +
            query +
            "&page=" +
            pageNumber.toString());
    Map<String, dynamic> movieMap =
    jsonDecode(utf8.decode(response.bodyBytes));
    List<Movie> moviesData = List<Movie>.from(
        movieMap["results"].map((item) => Movie.fromJson(item)));
    return moviesData;

  }

  Future<Movie> getDetailMovie(int movieId) async {
    final response = await get("/movie/" +
        movieId.toString() +
        "?api_key=35ef0461fc4557cf1d256d3335ed7545");
    Map<String, dynamic> movieMap =
    jsonDecode(utf8.decode(response.bodyBytes));
    Movie movie = Movie.fromJson(movieMap);
   return movie;

  }

}


