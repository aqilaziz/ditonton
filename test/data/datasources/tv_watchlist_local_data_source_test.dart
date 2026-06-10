import 'package:ditonton/data/datasources/tv_watchlist_local_data_source.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const series = TvSeriesModel(
    id: 10,
    title: 'Kingdom',
    posterUrl: '',
    rating: 8.7,
    overview: 'Zombie period drama.',
    genres: ['Action'],
    status: 'Ended',
    premiered: '2019-01-25',
  );

  test('adds, detects, and removes watchlist item', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final dataSource = TvWatchlistLocalDataSource(preferences);

    await dataSource.add(series);

    expect(await dataSource.contains(10), isTrue);
    expect((await dataSource.getWatchlist()).single.title, 'Kingdom');

    await dataSource.remove(10);

    expect(await dataSource.contains(10), isFalse);
    expect(await dataSource.getWatchlist(), isEmpty);
  });
}
