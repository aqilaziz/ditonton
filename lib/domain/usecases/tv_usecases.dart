import '../entities/tv_series.dart';
import '../repositories/tv_repository.dart';

class GetPopularTvSeries {
  GetPopularTvSeries(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute() => repository.getPopular();
}

class GetTopRatedTvSeries {
  GetTopRatedTvSeries(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute() => repository.getTopRated();
}

class GetAiringTodayTvSeries {
  GetAiringTodayTvSeries(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute() => repository.getAiringToday();
}

class SearchTvSeries {
  SearchTvSeries(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute(String query) => repository.search(query);
}

class GetTvSeriesDetail {
  GetTvSeriesDetail(this.repository);

  final TvRepository repository;

  Future<TvSeries> execute(int id) => repository.getDetail(id);
}

class GetTvSeriesRecommendations {
  GetTvSeriesRecommendations(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute(TvSeries series) {
    return repository.getRecommendations(series);
  }
}

class GetTvWatchlist {
  GetTvWatchlist(this.repository);

  final TvRepository repository;

  Future<List<TvSeries>> execute() => repository.getWatchlist();
}

class GetTvWatchlistStatus {
  GetTvWatchlistStatus(this.repository);

  final TvRepository repository;

  Future<bool> execute(int id) => repository.isInWatchlist(id);
}

class SaveTvWatchlist {
  SaveTvWatchlist(this.repository);

  final TvRepository repository;

  Future<void> execute(TvSeries series) => repository.addToWatchlist(series);
}

class RemoveTvWatchlist {
  RemoveTvWatchlist(this.repository);

  final TvRepository repository;

  Future<void> execute(int id) => repository.removeFromWatchlist(id);
}
