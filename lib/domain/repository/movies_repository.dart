import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';

//El repositorio que va a llamar el Datasource (Proposito: Llamar el datasource a traves del repositorio [intermediario])
//Sirve para cuando queremos cambiar nuestro origen de datos
<<<<<<< HEAD
abstract class MovieRepositories {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Review>> getMovieReviews(int movieId);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getByGenre(int genreId, {int page = 1});
  Future<List<Movie>> searchMovies(String query);
}
=======
abstract class MovieRepositories 
{
  Future<List<Movie>> getNowPlaying ({int page = 1});
  Future<List<Review>> getMovieReviews (int movieId);
}   
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
