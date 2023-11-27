
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    
    //! recordar que dentro de metodos se usa read() para que no se reescriba.
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId); //? se usa widget.movieId ya que "movieId" esta fuera del state en el que estoy (fuera del scope).
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId]; //? Del mapa de "movieInfoProvider" busca el elemento en la posicion "movieId".

    if (movie == null) {
      return const Scaffold(body: Center( child: CircularProgressIndicator(strokeWidth: 3,)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [

          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,

          )),

        ],
      ),
    );

  }
}

class _MovieDetails extends StatelessWidget {
  
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      children: [

        Padding(
          
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //? IMAGEN:
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(movie.posterPath, width: size.width * 0.3),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [


                      Icon(Icons.star_border_outlined, color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text("${movie.voteAverage}")
                    
                    ],
                  )
                ],
              ),

              const SizedBox(width: 10),

              //? DESCRIPCIÓN:
              SizedBox(
                width: (size.width - 40) * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(movie.title, style: textStyle.titleLarge),
                    const SizedBox(height: 5),
                    Text(movie.overview),

                  ],
                ),
              ),

            ],
          ),
        
        ),
        
        Padding(
          padding: const EdgeInsetsDirectional.all(8),
          child: Wrap(
            children: [

              ...movie.genreIds.map((genre) => Container(

                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(genre),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),

              ))

            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),

        

      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  
  final String movieId;

  const _ActorsByMovie({ required this.movieId });

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          
          final actor = actors[index];

          return FadeInRight(
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(actor.profilePath!, width: 180, height: 180, fit: BoxFit.cover,),
                  ),
          
                  const SizedBox(height: 5),
          
                  Text(actor.name, maxLines: 2, textAlign: TextAlign.center),
                  Text(actor.character ?? '', maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
          
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size; //? Almaceno las medidas del dispositivo.

    return SliverAppBar(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white, //? color de los elementos del sliver (botones, etc.).
      expandedHeight: size.height * 0.65,
      flexibleSpace: FlexibleSpaceBar(

        titlePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        background: Stack(
          children: [

            SizedBox.expand(

              child: Image.network(
                movie.posterPath, 
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),

            ),

            /*const SizedBox.expand(
              child: DecoratedBox(

                decoration: BoxDecoration(

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [Colors.transparent, Colors.black87]
                  )

                ),

              ),
            ),*/

            const SizedBox.expand(
              child: DecoratedBox(

                decoration: BoxDecoration(

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.2],
                    colors: [Colors.black45, Colors.transparent]
                  )

                ),

              ),
            ),

          ],
        ),

      ),
    );
  }
}