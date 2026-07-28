//En el datasources definimos como queremos que sea nuestros origenes de datos

//Clase abstracta porque no quiero crear instancias de ella
//Definimos como luce el origen de los datos que vamos a obtener
//Definir metodos para obtener la data

//ORIGEN DE DATOS
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor_detail.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie_image.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';

abstract class MovieDatasources {
  //Para definir la pagina en donde vamos a comenzar a consumir
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> searchMovies(String query);
  Future<List<Review>> getMovieReviews(int movieId);
  Future<List<Movie>> getByGenre(int genreId, {int page = 1});
  Future<List<Actor>> getMovieCast(int movieId);
  Future<String?> getMovieTrailerKey(int movieId);
  // NUEVO: detalle del actor (biografía, foto, etc.) y su filmografía
  Future<ActorDetail> getActorDetails(int actorId);
  Future<List<Movie>> getActorMovies(int actorId);
  // NUEVO: galería de imágenes de la película
  Future<List<MovieImage>> getMovieImages(int movieId);
}

//https://www.themoviedb.org/
//https://developer.themoviedb.org/docs/getting-started
