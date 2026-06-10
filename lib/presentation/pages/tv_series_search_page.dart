// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../bloc/tv_series_search_cubit.dart';
import '../widgets/tv_series_card.dart';

class TvSeriesSearchPage extends StatefulWidget {
  const TvSeriesSearchPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesSearchPage> createState() => _TvSeriesSearchPageState();
}

class _TvSeriesSearchPageState extends State<TvSeriesSearchPage> {
  void _search(String query) {
    context.read<TvSeriesSearchCubit>().fetchTvSeriesSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: _search,
              decoration: const InputDecoration(
                hintText: 'Search TV title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<TvSeriesSearchCubit, RequestState>(
                builder: (context, stateVersion) {
                  final provider = context.read<TvSeriesSearchCubit>();
                  if (provider.state == RequestState.Empty) {
                    return const SizedBox.shrink();
                  }
                  if (provider.state == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.state == RequestState.Error) {
                    return const Center(
                        child: Text('Failed to search TV Series'));
                  }
                  final results = provider.searchResult;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) => TvSeriesCard(
                      series: results[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
