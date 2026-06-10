import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'legacy_cubit_listener.dart';

class TvSeriesSearchCubit extends Cubit<RequestState>
    with LegacyCubitListener<RequestState> {
  TvSeriesSearchCubit({required this.searchTvSeries})
      : super(RequestState.Empty);

  final SearchTvSeries searchTvSeries;

  List<TvSeries> _searchResult = [];
  List<TvSeries> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeriesSearch(String query) async {
    if (query.trim().isEmpty) {
      _searchResult = [];
      emit(RequestState.Empty);
      return;
    }

    emit(RequestState.Loading);
    try {
      _searchResult = await searchTvSeries.execute(query);
      emit(RequestState.Loaded);
    } catch (error) {
      _message = error.toString();
      emit(RequestState.Error);
    }
  }
}
