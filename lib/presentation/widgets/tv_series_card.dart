// coverage:ignore-file
import 'package:flutter/material.dart';

import '../../domain/entities/tv_series.dart';
import '../pages/tv_series_detail_page.dart';

class TvSeriesCard extends StatelessWidget {
  const TvSeriesCard({
    Key? key,
    required this.series,
  }) : super(key: key);

  final TvSeries series;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: _Poster(url: series.posterUrl, width: 56, height: 84),
        title: Text(series.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          series.overview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(series.rating.toStringAsFixed(1)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TvSeriesDetailPage(
              series: series,
            ),
          ),
        ),
      ),
    );
  }
}

class TvPosterCard extends StatelessWidget {
  const TvPosterCard({
    Key? key,
    required this.series,
  }) : super(key: key);

  final TvSeries series;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TvSeriesDetailPage(
              series: series,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Poster(url: series.posterUrl)),
            const SizedBox(height: 8),
            Text(series.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text('Rating ${series.rating.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({
    required this.url,
    this.width,
    this.height,
  });

  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: const Color(0xFF303030),
      child: const Center(child: Icon(Icons.tv)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url.isEmpty
          ? placeholder
          : Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}
