import '../../domain/entities/tv_series.dart';
import '../../domain/repositories/tv_repository.dart';
import '../datasources/tv_remote_data_source.dart';
import '../datasources/tv_watchlist_local_data_source.dart';
import '../models/tv_series_model.dart';

class TvRepositoryImpl implements TvRepository {
  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TvRemoteDataSource remoteDataSource;
  final TvWatchlistLocalDataSource localDataSource;

  @override
  Future<List<TvSeries>> getPopular() => remoteDataSource.getPopular();

  @override
  Future<List<TvSeries>> getTopRated() => remoteDataSource.getTopRated();

  @override
  Future<List<TvSeries>> getAiringToday() => remoteDataSource.getAiringToday();

  @override
  Future<List<TvSeries>> search(String query) => remoteDataSource.search(query);

  @override
  Future<TvSeries> getDetail(int id) => remoteDataSource.getDetail(id);

  @override
  Future<List<TvSeries>> getRecommendations(TvSeries series) {
    return remoteDataSource
        .getRecommendations(TvSeriesModel.fromEntity(series));
  }

  @override
  Future<List<TvSeries>> getWatchlist() => localDataSource.getWatchlist();

  @override
  Future<bool> isInWatchlist(int id) => localDataSource.contains(id);

  @override
  Future<void> addToWatchlist(TvSeries series) {
    return localDataSource.add(TvSeriesModel.fromEntity(series));
  }

  @override
  Future<void> removeFromWatchlist(int id) => localDataSource.remove(id);
}
