import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class WatchlistMovieCubit extends Cubit<int> with LegacyCubitListener<int> {
  WatchlistMovieCubit({required this.getWatchlistMovies}) : super(0);

  final GetWatchlistMovies getWatchlistMovies;

  List<Movie> _watchlistMovies = [];
  List<Movie> get watchlistMovies => _watchlistMovies;

  RequestState _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    emit(state + 1);

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
      },
    );
    emit(state + 1);
  }
}
