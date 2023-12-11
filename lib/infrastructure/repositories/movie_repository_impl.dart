import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  
  final MoviesDataSource datasoruce;

  MovieRepositoryImpl(this.datasoruce);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasoruce.getNowPlaying(page: page);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasoruce.getPopular(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasoruce.getUpcoming(page: page);
  }
  
  @override
  Future<Movie> getMovieById(String id) {
    return datasoruce.getMovieById(id);
  }
  
  @override
  Future<List<Movie>> searchMovie(String query) {
    return datasoruce.searchMovie(query);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) {
    return datasoruce.getSimilarMovies(movieId);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) {
    return datasoruce.getYoutubeVideosById(movieId);
  }

}