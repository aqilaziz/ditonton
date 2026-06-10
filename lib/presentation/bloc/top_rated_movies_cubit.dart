import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class TopRatedMoviesCubit extends Cubit<RequestState>
    with LegacyCubitListener<RequestState> {
  TopRatedMoviesCubit({required this.getTopRatedMovies})
      : super(RequestState.Empty);

  final GetTopRatedMovies getTopRatedMovies;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedMovies() async {
    emit(RequestState.Loading);

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(RequestState.Error);
      },
      (moviesData) {
        _movies = moviesData;
        emit(RequestState.Loaded);
      },
    );
  }
}
