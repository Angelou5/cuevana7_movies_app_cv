import '../../domain/datasources/movies_datasources.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repository/movies_repository.dart';
import '../../domain/entities/review.dart';

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

}
