import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class TvSeriesListCubit extends Cubit<int> with LegacyCubitListener<int> {
  TvSeriesListCubit({
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
    required this.getAiringTodayTvSeries,
  }) : super(0);

  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetAiringTodayTvSeries getAiringTodayTvSeries;

  List<TvSeries> _popularSeries = [];
  List<TvSeries> get popularSeries => _popularSeries;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  List<TvSeries> _topRatedSeries = [];
  List<TvSeries> get topRatedSeries => _topRatedSeries;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  List<TvSeries> _airingTodaySeries = [];
  List<TvSeries> get airingTodaySeries => _airingTodaySeries;

  RequestState _airingTodayState = RequestState.Empty;
  RequestState get airingTodayState => _airingTodayState;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.Loading;
    emit(state + 1);
    try {
      _popularSeries = await getPopularTvSeries.execute();
      _popularState = RequestState.Loaded;
    } catch (error) {
      _popularState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    emit(state + 1);
    try {
      _topRatedSeries = await getTopRatedTvSeries.execute();
      _topRatedState = RequestState.Loaded;
    } catch (error) {
      _topRatedState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }

  Future<void> fetchAiringTodayTvSeries() async {
    _airingTodayState = RequestState.Loading;
    emit(state + 1);
    try {
      _airingTodaySeries = await getAiringTodayTvSeries.execute();
      _airingTodayState = RequestState.Loaded;
    } catch (error) {
      _airingTodayState = RequestState.Error;
      _message = error.toString();
    }
    emit(state + 1);
  }
}
