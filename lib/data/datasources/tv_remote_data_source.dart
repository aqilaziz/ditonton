import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:http/http.dart' as http;

import '../models/tv_series_model.dart';

class TvRemoteDataSource {
  TvRemoteDataSource({required this.client});

  final http.Client client;
  static const _apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<TvSeriesModel>> getPopular() => _getTvSeries('/tv/popular');

  Future<List<TvSeriesModel>> getTopRated() => _getTvSeries('/tv/top_rated');

  Future<List<TvSeriesModel>> getAiringToday() =>
      _getTvSeries('/tv/airing_today');

  Future<List<TvSeriesModel>> search(String query) async {
    if (query.trim().isEmpty) return const [];
    return _getTvSeries(
      '/search/tv',
      extraQuery: '&query=${Uri.encodeQueryComponent(query)}',
    );
  }

  Future<TvSeriesModel> getDetail(int id) async {
    final response = await client.get(Uri.parse('$_baseUrl/tv/$id?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesModel.fromTmdb(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw ServerException();
  }

  Future<List<TvSeriesModel>> getRecommendations(TvSeriesModel series) async {
    return _getTvSeries('/tv/${series.id}/recommendations');
  }

  Future<List<TvSeriesModel>> _getTvSeries(
    String path, {
    String extraQuery = '',
  }) async {
    final response =
        await client.get(Uri.parse('$_baseUrl$path?$_apiKey$extraQuery'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return List<TvSeriesModel>.from(
        (data['results'] as List)
            .map((item) => TvSeriesModel.fromTmdb(item as Map<String, dynamic>))
            .where((series) => series.posterUrl.isNotEmpty),
      );
    }
    throw ServerException();
  }
}
