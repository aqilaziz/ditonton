import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses TMDB list response', () {
    final model = TvSeriesModel.fromTmdb({
      'id': 1,
      'name': 'Undercover',
      'poster_path': '/poster.jpg',
      'vote_average': 8.2,
      'overview': 'A spy family story.',
      'genre_ids': [18, 80],
      'first_air_date': '2024-01-01',
    });

    expect(model.id, 1);
    expect(model.title, 'Undercover');
    expect(model.posterUrl, 'https://image.tmdb.org/t/p/w500/poster.jpg');
    expect(model.rating, 8.2);
    expect(model.overview, 'A spy family story.');
    expect(model.genres, ['Drama', 'Crime']);
  });

  test('parses TMDB detail response', () {
    final model = TvSeriesModel.fromTmdb({
      'id': 3,
      'name': 'Detail Show',
      'poster_path': null,
      'vote_average': 7.5,
      'overview': 'Detailed overview.',
      'genres': [
        {'id': 18, 'name': 'Drama'},
        {'id': 9648, 'name': 'Mystery'},
      ],
      'status': 'Returning Series',
      'first_air_date': '2025-02-03',
    });

    expect(model.posterUrl, '');
    expect(model.status, 'Returning Series');
    expect(model.premiered, '2025-02-03');
    expect(model.genres, ['Drama', 'Mystery']);
  });

  test('serializes watchlist item', () {
    const model = TvSeriesModel(
      id: 2,
      title: 'Signal',
      posterUrl: '',
      rating: 9,
      overview: 'Detective drama.',
      genres: ['Mystery'],
      status: 'Ended',
      premiered: '2016-01-22',
    );

    final restored = TvSeriesModel.fromJson(model.toJson());

    expect(restored.id, model.id);
    expect(restored.title, model.title);
    expect(restored.genres, model.genres);
  });
}
