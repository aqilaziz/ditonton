// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../bloc/tv_series_list_cubit.dart';
import '../widgets/tv_series_card.dart';

enum TvSeriesCategory { popular, topRated, airingToday }

class TvSeriesListPage extends StatefulWidget {
  const TvSeriesListPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final TvSeriesCategory category;

  @override
  State<TvSeriesListPage> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  String get _title {
    switch (widget.category) {
      case TvSeriesCategory.popular:
        return 'Popular TV Series';
      case TvSeriesCategory.topRated:
        return 'Top Rated TV Series';
      case TvSeriesCategory.airingToday:
        return 'Airing Today';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadItems);
  }

  void _loadItems() {
    final provider = context.read<TvSeriesListCubit>();
    switch (widget.category) {
      case TvSeriesCategory.popular:
        provider.fetchPopularTvSeries();
        break;
      case TvSeriesCategory.topRated:
        provider.fetchTopRatedTvSeries();
        break;
      case TvSeriesCategory.airingToday:
        provider.fetchAiringTodayTvSeries();
        break;
    }
  }

  RequestState _state(TvSeriesListCubit provider) {
    switch (widget.category) {
      case TvSeriesCategory.popular:
        return provider.popularState;
      case TvSeriesCategory.topRated:
        return provider.topRatedState;
      case TvSeriesCategory.airingToday:
        return provider.airingTodayState;
    }
  }

  List<TvSeries> _items(TvSeriesListCubit provider) {
    switch (widget.category) {
      case TvSeriesCategory.popular:
        return provider.popularSeries;
      case TvSeriesCategory.topRated:
        return provider.topRatedSeries;
      case TvSeriesCategory.airingToday:
        return provider.airingTodaySeries;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: BlocBuilder<TvSeriesListCubit, int>(
        builder: (context, stateVersion) {
          final provider = context.read<TvSeriesListCubit>();
          final state = _state(provider);
          if (state == RequestState.Empty || state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state == RequestState.Error) {
            return Center(child: Text('Failed to load $_title'));
          }
          final items = _items(provider);
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) => TvSeriesCard(
              series: items[index],
            ),
          );
        },
      ),
    );
  }
}
