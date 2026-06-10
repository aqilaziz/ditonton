import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class MovieListCubit extends Cubit<int> with LegacyCubitListener<int> {
  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(0);

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  RequestState _popularMoviesState = RequestState.Empty;
  RequestState get popularMoviesState => _popularMoviesState;

  List<Movie> _topRatedMovies = [];
  List<Movie> get topRatedMovies => _topRatedMovies;

  RequestState _topRatedMoviesState = RequestState.Empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = RequestState.Loading;
    emit(state + 1);

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
      },
      (moviesData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingMovies = moviesData;
      },
    );
    emit(state + 1);
  }

  Future<void> fetchPopularMovies() async {
    _popularMoviesState = RequestState.Loading;
    emit(state + 1);

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        _popularMoviesState = RequestState.Error;
        _message = failure.message;
      },
      (moviesData) {
        _popularMoviesState = RequestState.Loaded;
        _popularMovies = moviesData;
      },
    );
    emit(state + 1);
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState = RequestState.Loading;
    emit(state + 1);

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _topRatedMoviesState = RequestState.Error;
        _message = failure.message;
      },
      (moviesData) {
        _topRatedMoviesState = RequestState.Loaded;
        _topRatedMovies = moviesData;
      },
    );
    emit(state + 1);
  }
}
