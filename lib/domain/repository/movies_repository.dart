import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';

//El repositorio que va a llamar el Datasource (Proposito: Llamar el datasource a traves del repositorio [intermediario])
//Sirve para cuando queremos cambiar nuestro origen de datos
abstract class MovieRepositories {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Review>> getMovieReviews(int movieId);
  Future<List<Movie>> getByGenre(int genreId, {int page = 1});
  Future<List<Movie>> searchMovies(String query);
  Future<List<Actor>> getMovieCast(int movieId);
  Future<String?> getMovieTrailerKey(int movieId);
}
