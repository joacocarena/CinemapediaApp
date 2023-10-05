import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MoviesDataSource {
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    //! RECORDAR QUE PARA HACER UNA PETICION HTTP SE USA UNA FUNCION ASYNC.
    final response = await dio.get('/movie/now_playing',
      queryParameters: {
        'page': page
      }
    ); //? con dio.get hago la petición get.
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster')
    .map((moviedb) => MovieMapper.movieDBToEntity(moviedb)).toList();


    return movies;
  
  }



  

}