import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class MovieSearchCubit extends Cubit<RequestState>
    with LegacyCubitListener<RequestState> {
  MovieSearchCubit({required this.searchMovies}) : super(RequestState.Empty);

  final SearchMovies searchMovies;

  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchMovieSearch(String query) async {
    emit(RequestState.Loading);

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        emit(RequestState.Error);
      },
      (data) {
        _searchResult = data;
        emit(RequestState.Loaded);
      },
    );
  }
}
