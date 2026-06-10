import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTvRepository implements TvRepository {
  final List<TvSeries> items = const [
    TvSeries(
      id: 1,
      title: 'Usecase Show',
      posterUrl: '',
      rating: 8,
      overview: 'Overview',
      genres: ['Drama'],
      status: 'Running',
      premiered: '2021-01-01',
    ),
  ];
  bool added = false;

  @override
  Future<void> addToWatchlist(TvSeries series) async {
    added = true;
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
  Future<List<TvSeries>> getWatchlist() async => items;

  @override
  Future<bool> isInWatchlist(int id) async => added;

  @override
  Future<void> removeFromWatchlist(int id) async {
    added = false;
  }

  @override
  Future<List<TvSeries>> search(String query) async => items;
}

void main() {
  test('usecases call repository contracts', () async {
    final repository = FakeTvRepository();

    expect(
      (await GetPopularTvSeries(repository).execute()).single.title,
      'Usecase Show',
    );
    expect((await GetTopRatedTvSeries(repository).execute()).single.id, 1);
    expect(
      (await GetAiringTodayTvSeries(repository).execute()).single.status,
      'Running',
    );
    expect(
      (await SearchTvSeries(repository).execute('show')).single.title,
      'Usecase Show',
    );
    expect(await GetTvSeriesDetail(repository).execute(1),
        repository.items.single);
    expect(
      (await GetTvSeriesRecommendations(repository)
              .execute(repository.items.single))
          .single
          .id,
      1,
    );

    await SaveTvWatchlist(repository).execute(repository.items.single);

    expect(await GetTvWatchlistStatus(repository).execute(1), isTrue);
    expect((await GetTvWatchlist(repository).execute()).single.id, 1);

    await RemoveTvWatchlist(repository).execute(1);

    expect(await GetTvWatchlistStatus(repository).execute(1), isFalse);
  });
}
