import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {

    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();

  }
  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final upComingMovies = ref.watch(upcomingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);

    return CustomScrollView ( 

      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar (
            title: CustomAppbar(),
            titlePadding: EdgeInsets.only(left: 2, bottom: 10),
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) {
            
            return Column(
              children: [

                MoviesSlideshow(movies: slideShowMovies),
                MovieHorizontalListview (
                  movies: nowPlayingMovies, 
                  title: 'Movies on Cinema',
                  subTitle: 'Monday 20th',
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                MovieHorizontalListview (
                  movies: upComingMovies, 
                  title: 'Upcoming',
                  subTitle: 'This Month',
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                MovieHorizontalListview (
                  movies: popularMovies, 
                  title: 'Popular Movies',
                  //subTitle: 'Lunes 20',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),

                const SizedBox(height: 10)

              ],
            );
          },

          childCount: 1

        )),
      ], 
    );
  }
}