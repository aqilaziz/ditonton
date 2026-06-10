import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_watchlist_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTvRepository implements TvRepository {
  final items = <TvSeries>[
    const TvSeries(
      id: 1,
      title: 'Bloc Show',
      posterUrl: '',
      rating: 8,
      overview: 'Overview',
      genres: ['Drama'],
      status: 'Running',
      premiered: '2021-01-01',
    ),
  ];
  final watchlist = <TvSeries>[];

  @override
  Future<void> addToWatchlist(TvSeries series) async {
    watchlist
      ..removeWhere((item) => item.id == series.id)
      ..add(series);
  }

  @override
  Future<List<TvSeries>> getAiringToday() async => items;

  @override
  Future<TvSeries> getDetail(int id) async => items.single;

  @override
  Future<List<TvSeries>> getPopular() async => items;

  @override
  Future<List<TvSeries>> getRecommendations(TvSeries series) async => items;

  @override
  Future<List<TvSeries>> getTopRated() async => items;

  @override
  Future<List<TvSeries>> getWatchlist() async => List.unmodifiable(watchlist);

  @override
  Future<bool> isInWatchlist(int id) async {
    return watchlist.any((item) => item.id == id);
  }

  @override
  Future<void> removeFromWatchlist(int id) async {
    watchlist.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<TvSeries>> search(String query) async => items;
}

void main() {
  late FakeTvRepository repository;

  setUp(() {
    repository = FakeTvRepository();
  });

  test('TV list notifier loads data through usecases', () async {
    final notifier = TvSeriesListCubit(
      getPopularTvSeries: GetPopularTvSeries(repository),
      getTopRatedTvSeries: GetTopRatedTvSeries(repository),
      getAiringTodayTvSeries: GetAiringTodayTvSeries(repository),
    );

    await notifier.fetchPopularTvSeries();
    await notifier.fetchTopRatedTvSeries();
    await notifier.fetchAiringTodayTvSeries();

    expect(notifier.popularState, RequestState.Loaded);
    expect(notifier.topRatedState, RequestState.Loaded);
    expect(notifier.airingTodayState, RequestState.Loaded);
    expect(notifier.popularSeries.single.title, 'Bloc Show');
  });

  test('TV search notifier loads results through usecase', () async {
    final notifier = TvSeriesSearchCubit(
      searchTvSeries: SearchTvSeries(repository),
    );

    await notifier.fetchTvSeriesSearch('bloc');

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.searchResult.single.id, 1);
  });

  test('TV detail notifier updates watchlist status through usecases',
      () async {
    final notifier = TvSeriesDetailCubit(
      getTvSeriesDetail: GetTvSeriesDetail(repository),
      getTvSeriesRecommendations: GetTvSeriesRecommendations(repository),
      getTvWatchlistStatus: GetTvWatchlistStatus(repository),
      saveTvWatchlist: SaveTvWatchlist(repository),
      removeTvWatchlist: RemoveTvWatchlist(repository),
    );
    final series = repository.items.single;

    await notifier.fetchTvSeriesDetail(series.id);
    await notifier.fetchRecommendations(series);
    await notifier.addWatchlist(series);

    expect(notifier.seriesState, RequestState.Loaded);
    expect(notifier.series, series);
    expect(notifier.recommendationState, RequestState.Loaded);
    expect(notifier.recommendations.single.id, 1);
    expect(notifier.isAddedToWatchlist, isTrue);

    await notifier.removeFromWatchlist(series);

    expect(notifier.isAddedToWatchlist, isFalse);
  });

  test('TV watchlist notifier reloads current storage state', () async {
    final notifier = TvSeriesWatchlistCubit(
      getTvWatchlist: GetTvWatchlist(repository),
    );
    final series = repository.items.single;

    await repository.addToWatchlist(series);
    await notifier.fetchWatchlist();

    expect(notifier.watchlist, [series]);

    await repository.removeFromWatchlist(series.id);
    await notifier.fetchWatchlist();

    expect(notifier.watchlist, isEmpty);
  });
}
