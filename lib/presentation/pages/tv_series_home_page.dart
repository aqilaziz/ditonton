// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../bloc/tv_series_list_cubit.dart';
import 'tv_series_list_page.dart';
import 'tv_series_search_page.dart';
import 'tv_series_watchlist_page.dart';
import '../widgets/tv_series_card.dart';

class TvSeriesHomePage extends StatefulWidget {
  const TvSeriesHomePage({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/tv-series';

  @override
  State<TvSeriesHomePage> createState() => _TvSeriesHomePageState();
}

class _TvSeriesHomePageState extends State<TvSeriesHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesListCubit>()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries()
        ..fetchAiringTodayTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            tooltip: 'Search TV Series',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TvSeriesSearchPage()),
            ),
          ),
          IconButton(
            tooltip: 'TV Watchlist',
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TvSeriesWatchlistPage()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TvSeriesListCubit, int>(
        builder: (context, stateVersion) {
          final data = context.read<TvSeriesListCubit>();
          final states = [
            data.popularState,
            data.topRatedState,
            data.airingTodayState,
          ];
          if (states.any((state) =>
              state == RequestState.Empty || state == RequestState.Loading)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (states.any((state) => state == RequestState.Error)) {
            return _ErrorView(
              message: 'Failed to load TV Series',
              onRetry: () {
                data
                  ..fetchPopularTvSeries()
                  ..fetchTopRatedTvSeries()
                  ..fetchAiringTodayTvSeries();
              },
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _TvSection(
                title: 'Popular TV Series',
                series: data.popularSeries,
                onSeeMore: () => _openList(TvSeriesCategory.popular),
              ),
              _TvSection(
                title: 'Top Rated TV Series',
                series: data.topRatedSeries,
                onSeeMore: () => _openList(TvSeriesCategory.topRated),
              ),
              _TvSection(
                title: 'Airing Today',
                series: data.airingTodaySeries,
                onSeeMore: () => _openList(TvSeriesCategory.airingToday),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openList(TvSeriesCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TvSeriesListPage(
          category: category,
        ),
      ),
    );
  }
}

class _TvSection extends StatelessWidget {
  const _TvSection({
    required this.title,
    required this.series,
    required this.onSeeMore,
  });

  final String title;
  final List<TvSeries> series;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: kHeading6),
              InkWell(
                onTap: onSeeMore,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text('See More'),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: series.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => TvPosterCard(
                series: series[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
