//En el datasources definimos como queremos que sea nuestros origenes de datos

//Clase abstracta porque no quiero crear instancias de ella
//Definimos como luce el origen de los datos que vamos a obtener
//Definir metodos para obtener la data

//ORIGEN DE DATOS
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';

abstract class MovieDatasources {
  //Para definir la pagina en donde vamos a comenzar a consumir
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Review>> getMovieReviews(int movieId);

  //para devolver la lista de peliculas filtradas por genero familia
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
}

//https://www.themoviedb.org/
//https://developer.themoviedb.org/docs/getting-started
