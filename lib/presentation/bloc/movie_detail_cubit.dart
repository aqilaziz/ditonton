import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class MovieDetailCubit extends Cubit<int> with LegacyCubitListener<int> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(0);

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.Empty;
  RequestState get movieState => _movieState;

  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.Loading;
    emit(state + 1);

    final detailResult = await getMovieDetail.execute(id);
    await detailResult.fold(
      (failure) async {
        _movieState = RequestState.Error;
        _message = failure.message;
        emit(state + 1);
      },
      (movie) async {
        _movie = movie;
        _movieState = RequestState.Loaded;
        _recommendationState = RequestState.Loading;
        emit(state + 1);

        final recommendationResult =
            await getMovieRecommendations.execute(movie.id);
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = RequestState.Loaded;
            _movieRecommendations = movies;
          },
        );
        emit(state + 1);
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );
    _isAddedToWatchlist = await getWatchListStatus.execute(movie.id);
    emit(state + 1);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );
    _isAddedToWatchlist = await getWatchListStatus.execute(movie.id);
    emit(state + 1);
  }

  Future<void> loadWatchlistStatus(int id) async {
    _isAddedToWatchlist = await getWatchListStatus.execute(id);
    emit(state + 1);
  }
}
