// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/state_enum.dart';
import '../../common/utils.dart';
import '../bloc/tv_series_watchlist_cubit.dart';
import '../widgets/tv_series_card.dart';

class TvSeriesWatchlistPage extends StatefulWidget {
  const TvSeriesWatchlistPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesWatchlistPage> createState() => _TvSeriesWatchlistPageState();
}

class _TvSeriesWatchlistPageState extends State<TvSeriesWatchlistPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TvSeriesWatchlistCubit>().fetchWatchlist());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    context.read<TvSeriesWatchlistCubit>().fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TV Series Watchlist')),
      body: BlocBuilder<TvSeriesWatchlistCubit, int>(
        builder: (context, stateVersion) {
          final provider = context.read<TvSeriesWatchlistCubit>();
          if (provider.watchlistState == RequestState.Empty ||
              provider.watchlistState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.watchlistState == RequestState.Error) {
            return const Center(child: Text('Failed to load TV watchlist'));
          }
          final items = provider.watchlist;
          if (items.isEmpty) {
            return const Center(child: Text('TV Series watchlist is empty'));
          }
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
