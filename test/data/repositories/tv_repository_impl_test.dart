import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_watchlist_local_data_source.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const payload = '''
{
  "results": [
    {
      "id": 11,
      "name": "Repository Show",
      "poster_path": "/repository.jpg",
      "vote_average": 8.5,
      "overview": "Repository summary",
      "genre_ids": [18],
      "first_air_date": "2022-02-02"
    }
  ]
}
''';
  const detailPayload = '''
{
  "id": 11,
  "name": "Repository Detail",
  "poster_path": "/repository.jpg",
  "vote_average": 8.7,
  "overview": "Repository detail summary",
  "genres": [{"id": 18, "name": "Drama"}],
  "status": "Ended",
  "first_air_date": "2022-02-02"
  }
''';

  test('delegates remote and local data sources', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = TvRepositoryImpl(
      remoteDataSource: TvRemoteDataSource(
        client: MockClient((request) async {
          if (request.url.path == '/3/tv/11') {
            return http.Response(detailPayload, 200);
          }
          return http.Response(payload, 200);
        }),
      ),
      localDataSource: TvWatchlistLocalDataSource(preferences),
    );

    final show = (await repository.getPopular()).single;

    expect(show.title, 'Repository Show');
    expect((await repository.getDetail(show.id)).title, 'Repository Detail');
    expect(await repository.isInWatchlist(show.id), isFalse);

    await repository.addToWatchlist(show);

    expect(await repository.isInWatchlist(show.id), isTrue);
    expect((await repository.getWatchlist()).single.id, show.id);

    await repository.removeFromWatchlist(show.id);

    expect(await repository.getWatchlist(), isEmpty);
  });
}
