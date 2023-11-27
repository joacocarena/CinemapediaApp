
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? Creo el provider para la implementación:
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {

  final actorsRepository = ref.watch(actorsRepositoryProvider);
  return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);

});


/*

  {
    '501010': <Actor>[], primer columna es el movieId y devuelve un listado de actores pertenecientes a esa pelicula.
    '121232': <Actor>[],
    '432231': <Actor>[],
    '659503': <Actor>[],
  }

*/

typedef GetActorsCallback = Future<List<Actor>>Function( String movieId );

class ActorsByMovieNotifier extends StateNotifier <Map<String, List<Actor>>>{

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}): super({});

  Future<void> loadActors( String movieId ) async {

    //! ver ejemp de state (map) de arriba.
    if (state[movieId] != null) return; //? Si existe una peli (en el state) que coincide con "movieId" entonces no hace nada.

    final List<Actor> actors = await getActors(movieId); //? de caso contrario, mando a llamar la pelicula para su implementación 
    state = { ...state, movieId: actors }; //? actualizo el estado: clonando el estado anterior (con spread operator ...) y agrego el nuevo "movieId" que apunta a la nueva movie.
  }

}