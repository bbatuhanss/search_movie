import 'package:flutter_test/flutter_test.dart';
import 'package:project_movie_search/models/movie.dart';
import 'package:project_movie_search/services/movie_service.dart';

void main() {
  MovieService? movieService;
  setUp((){
    movieService = MovieService();
  });
 test("MovieId", (){
   final movie = Movie(movieId: 1);

   expect(movie.movieId.isNegative,false);
 });

 test("Search Movie", () async{

    final response = await movieService!.getSearchMovie("the",1);

   expect(response is List<Movie>,true);
 });

 test("Movie Detail", () async{

   final response = await movieService!.getDetailMovie(121);

   expect(response is Movie,true);
 });

}
