import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const listPayload = '''
{
  "results": [
    {
      "id": 1,
      "name": "Alpha",
      "poster_path": "/alpha.jpg",
      "vote_average": 7.0,
      "overview": "Alpha summary",
      "genre_ids": [18],
      "first_air_date": "2024-01-01"
    },
    {
      "id": 2,
      "name": "Beta",
      "poster_path": "/beta.jpg",
      "vote_average": 9.0,
      "overview": "Beta summary",
      "genre_ids": [35],
      "first_air_date": "2020-01-01"
    }
  ]
}
''';
  const searchPayload = '''
{
  "results": [
    {
      "id": 3,
      "name": "Gamma",
      "poster_path": "/gamma.jpg",
      "vote_average": 0,
      "overview": "",
      "genre_ids": [],
      "first_air_date": ""
    }
  ]
}
''';
  const detailPayload = '''
{
  "id": 1,
  "name": "Alpha Detail",
  "poster_path": "/alpha-detail.jpg",
  "vote_average": 7.5,
  "overview": "Alpha detail summary",
  "genres": [{"id": 18, "name": "Drama"}],
  "status": "Returning Series",
  "first_air_date": "2024-01-01"
}
''';

  TvRemoteDataSource dataSource() {
    return TvRemoteDataSource(
      client: MockClient((request) async {
        expect(request.url.queryParameters['api_key'], isNotEmpty);
        if (request.url.path == '/3/tv/popular' ||
            request.url.path == '/3/tv/top_rated' ||
            request.url.path == '/3/tv/airing_today' ||
            request.url.path == '/3/tv/1/recommendations') {
          return http.Response(listPayload, 200);
        }
        if (request.url.path == '/3/search/tv') {
          expect(request.url.queryParameters['query'], 'gamma');
          return http.Response(searchPayload, 200);
        }
        if (request.url.path == '/3/tv/1') {
          return http.Response(detailPayload, 200);
        }
        return http.Response('Not found', 404);
      }),
    );
  }

  test('loads popular, top rated, and airing today lists', () async {
    final source = dataSource();

    final popular = await source.getPopular();
    final topRated = await source.getTopRated();
    final airing = await source.getAiringToday();

    expect(popular.map((e) => e.title), ['Alpha', 'Beta']);
    expect(topRated.map((e) => e.title), ['Alpha', 'Beta']);
    expect(airing.map((e) => e.title), ['Alpha', 'Beta']);
    expect(
        popular.first.posterUrl, 'https://image.tmdb.org/t/p/w500/alpha.jpg');
  });

  test('searches title from API', () async {
    final results = await dataSource().search('gamma');

    expect(results.single.title, 'Gamma');
    expect(
        results.single.posterUrl, 'https://image.tmdb.org/t/p/w500/gamma.jpg');
  });

  test('loads detail from TMDB API', () async {
    final detail = await dataSource().getDetail(1);

    expect(detail.title, 'Alpha Detail');
    expect(detail.status, 'Returning Series');
    expect(detail.genres, ['Drama']);
  });

  test('loads recommendations from TMDB API', () async {
    final source = dataSource();
    final alpha = (await source.getPopular()).first;

    final recommendations = await source.getRecommendations(alpha);

    expect(recommendations.map((e) => e.title), ['Alpha', 'Beta']);
  });
}
