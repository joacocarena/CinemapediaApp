
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? Creo el provider para la implementación:
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {

  final movieRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);

});


/*

  {
    '501010': Movie(), primer columna es el movieId y devuelve una instancia de Movie.
    '121232': Movie(),
    '432231': Movie(),
    '659503': Movie(),
  }

*/

typedef GetMovieCallback = Future<Movie>Function( String movieId );

class MovieMapNotifier extends StateNotifier <Map<String, Movie>>{

  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}): super({});

  Future<void> loadMovie( String movieId ) async {

    //! ver ejemp de state (map) de arriba.
    if (state[movieId] != null) return; //? Si existe una peli (en el state) que coincide con "movieId" entonces no hace nada.

    final movie = await getMovie(movieId); //? de caso contrario, mando a llamar la pelicula para su implementación 
    state = { ...state, movieId: movie }; //? actualizo el estado: clonando el estado anterior (con spread operator ...) y agrego el nuevo "movieId" que apunta a la nueva movie.
  }

}