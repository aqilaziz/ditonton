// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../bloc/tv_series_detail_cubit.dart';
import '../widgets/tv_series_card.dart';

class TvSeriesDetailPage extends StatefulWidget {
  const TvSeriesDetailPage({
    Key? key,
    required this.series,
  }) : super(key: key);

  final TvSeries series;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailCubit>()
        ..loadWatchlistStatus(widget.series.id)
        ..fetchTvSeriesDetail(widget.series.id)
        ..fetchRecommendations(widget.series);
    });
  }

  Future<void> _toggleWatchlist(bool added) async {
    final provider = context.read<TvSeriesDetailCubit>();
    final series = provider.series ?? widget.series;
    if (added) {
      await provider.removeFromWatchlist(series);
    } else {
      await provider.addWatchlist(series);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.watchlistMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.series.title)),
      body: BlocBuilder<TvSeriesDetailCubit, int>(
        builder: (context, stateVersion) {
          final provider = context.read<TvSeriesDetailCubit>();
          final series = provider.series ?? widget.series;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Poster(url: series.posterUrl),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(series.title, style: kHeading5),
                        const SizedBox(height: 8),
                        Text('Rating: ${series.rating.toStringAsFixed(1)}'),
                        Text('Status: ${series.status}'),
                        Text('Premiered: ${series.premiered}'),
                        const SizedBox(height: 8),
                        Text(series.genres.join(', ')),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _toggleWatchlist(provider.isAddedToWatchlist),
                          icon: Icon(
                            provider.isAddedToWatchlist
                                ? Icons.bookmark_remove
                                : Icons.bookmark_add,
                          ),
                          label: Text(
                            provider.isAddedToWatchlist
                                ? 'Remove Watchlist'
                                : 'Add Watchlist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (provider.seriesState == RequestState.Loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              const SizedBox(height: 24),
              Text('Overview', style: kHeading6),
              const SizedBox(height: 8),
              Text(series.overview),
              const SizedBox(height: 24),
              Text('Recommendations', style: kHeading6),
              const SizedBox(height: 12),
              _RecommendationList(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

class _RecommendationList extends StatelessWidget {
  const _RecommendationList({required this.provider});

  final TvSeriesDetailCubit provider;

  @override
  Widget build(BuildContext context) {
    if (provider.recommendationState == RequestState.Empty ||
        provider.recommendationState == RequestState.Loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.recommendationState == RequestState.Error) {
      return const Text('Failed to load recommendations');
    }
    final recommendations = provider.recommendations;
    return SizedBox(
      height: 235,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => TvPosterCard(
          series: recommendations[index],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 120,
      height: 180,
      color: const Color(0xFF303030),
      child: const Icon(Icons.tv),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url.isEmpty
          ? placeholder
          : Image.network(
              url,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}
