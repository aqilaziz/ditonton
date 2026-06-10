import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_watchlist_local_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv_usecases.dart';
import 'package:ditonton/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series_watchlist_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(
    () => MovieListCubit(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchCubit(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesCubit(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieCubit(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesListCubit(
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
      getAiringTodayTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchCubit(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailCubit(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getTvWatchlistStatus: locator(),
      saveTvWatchlist: locator(),
      removeTvWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesWatchlistCubit(
      getTvWatchlist: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetAiringTodayTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSource(client: locator()));
  locator.registerLazySingleton<TvWatchlistLocalDataSource>(
      () => TvWatchlistLocalDataSource(locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  final preferences = await SharedPreferences.getInstance();
  final httpClient = await SslPinnedHttpClient.create();
  locator.registerLazySingleton<SharedPreferences>(() => preferences);
  locator.registerLazySingleton<http.Client>(() => httpClient);
}
