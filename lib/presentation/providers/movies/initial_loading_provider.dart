import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
    final step1 = ref.watch( nowPlayingMoviesProvider ).isEmpty;
    final step2 = ref.watch( upcomingMoviesProvider ).isEmpty;
    final step3 = ref.watch( popularMoviesProvider ).isEmpty;

    if (step1 || step2 || step3) return true;
    return false; //? termina la carga.
});