import '../../domain/datasources/movies_datasources.dart';
import '../../domain/entities/actor.dart';
import '../../domain/entities/actor_detail.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_image.dart';
import '../../domain/entities/review.dart';
import '../../domain/repository/movies_repository.dart';

class MovieRepositoryImpl implements MovieRepositories {
  final MovieDatasources datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Review>> getMovieReviews(int movieId) {
    return datasource.getMovieReviews(movieId);
  }

  @override
  Future<List<Movie>> getByGenre(int genreId, {int page = 1}) {
    return datasource.getByGenre(genreId, page: page);
  }

  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query);
  }

  // NUEVO
  @override
  Future<List<Actor>> getMovieCast(int movieId) {
    return datasource.getMovieCast(movieId);
  }

  //Nuevo consumo para trailer de la pelicula
  @override
  Future<String?> getMovieTrailerKey(int movieId) {
    return datasource.getMovieTrailerKey(movieId);
  }

  // NUEVO: detalle del actor y su filmografía
  @override
  Future<ActorDetail> getActorDetails(int actorId) {
    return datasource.getActorDetails(actorId);
  }

  @override
  Future<List<Movie>> getActorMovies(int actorId) {
    return datasource.getActorMovies(actorId);
  }

  // NUEVO: galería de imágenes de la película
  @override
  Future<List<MovieImage>> getMovieImages(int movieId) {
    return datasource.getMovieImages(movieId);
  }
}
