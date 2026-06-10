import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class TvSeriesDetailCubit extends Cubit<int> with LegacyCubitListener<int> {
  TvSeriesDetailCubit({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getTvWatchlistStatus,
    required this.saveTvWatchlist,
    required this.removeTvWatchlist,
  }) : super(0);

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetTvWatchlistStatus getTvWatchlistStatus;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;

  TvSeries? _series;
  TvSeries? get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<TvSeries> _recommendations = [];
  List<TvSeries> get recommendations => _recommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _message = '';
  String get message => _message;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    emit(state + 1);
    try {
      _series = await getTvSeriesDetail.execute(id);
      _seriesState = RequestState.Loaded;
    } catch (error) {
      _seriesState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }

  Future<void> fetchRecommendations(TvSeries series) async {
    _recommendationState = RequestState.Loading;
    emit(state + 1);
    try {
      _recommendations = await getTvSeriesRecommendations.execute(series);
      _recommendationState = RequestState.Loaded;
    } catch (error) {
      _recommendationState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }

  Future<void> addWatchlist(TvSeries series) async {
    try {
      await saveTvWatchlist.execute(series);
      _watchlistMessage = watchlistAddSuccessMessage;
    } catch (error) {
      _watchlistMessage = error.toString();
    }
    _isAddedToWatchlist = await getTvWatchlistStatus.execute(series.id);
    emit(state + 1);
  }

  Future<void> removeFromWatchlist(TvSeries series) async {
    try {
      await removeTvWatchlist.execute(series.id);
      _watchlistMessage = watchlistRemoveSuccessMessage;
    } catch (error) {
      _watchlistMessage = error.toString();
    }
    _isAddedToWatchlist = await getTvWatchlistStatus.execute(series.id);
    emit(state + 1);
  }

  Future<void> loadWatchlistStatus(int id) async {
    _isAddedToWatchlist = await getTvWatchlistStatus.execute(id);
    emit(state + 1);
  }
}
