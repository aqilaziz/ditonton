import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class PopularMoviesCubit extends Cubit<RequestState>
    with LegacyCubitListener<RequestState> {
  PopularMoviesCubit(this.getPopularMovies) : super(RequestState.Empty);

  final GetPopularMovies getPopularMovies;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularMovies() async {
    emit(RequestState.Loading);

    final result = await getPopularMovies.execute();
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
