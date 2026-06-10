import '../entities/tv_series.dart';

abstract class TvRepository {
  Future<List<TvSeries>> getPopular();

  Future<List<TvSeries>> getTopRated();

  Future<List<TvSeries>> getAiringToday();

  Future<List<TvSeries>> search(String query);

  Future<TvSeries> getDetail(int id);

  Future<List<TvSeries>> getRecommendations(TvSeries series);

  Future<List<TvSeries>> getWatchlist();

  Future<bool> isInWatchlist(int id);

  Future<void> addToWatchlist(TvSeries series);

  Future<void> removeFromWatchlist(int id);
}
