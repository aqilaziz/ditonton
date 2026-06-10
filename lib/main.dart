import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/firebase_monitoring.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series_home_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
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
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMonitoring.initialize();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesWatchlistCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          if (FirebaseMonitoring.analytics != null)
            FirebaseAnalyticsObserver(
              analytics: FirebaseMonitoring.analytics!,
            ),
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case TvSeriesHomePage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => TvSeriesHomePage(),
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
