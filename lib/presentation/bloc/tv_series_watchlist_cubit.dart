import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class TvSeriesWatchlistCubit extends Cubit<int> with LegacyCubitListener<int> {
  TvSeriesWatchlistCubit({required this.getTvWatchlist}) : super(0);

  final GetTvWatchlist getTvWatchlist;

  List<TvSeries> _watchlist = [];
  List<TvSeries> get watchlist => _watchlist;

  RequestState _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.Loading;
    emit(state + 1);
    try {
      _watchlist = await getTvWatchlist.execute();
      _watchlistState = RequestState.Loaded;
    } catch (error) {
      _watchlistState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }
}
