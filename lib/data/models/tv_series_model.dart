import '../../common/constants.dart';
import '../../domain/entities/tv_series.dart';

class TvSeriesModel extends TvSeries {
  const TvSeriesModel({
    required super.id,
    required super.title,
    required super.posterUrl,
    required super.rating,
    required super.overview,
    required super.genres,
    required super.status,
    required super.premiered,
  });

  factory TvSeriesModel.fromTmdb(Map<String, dynamic> json) {
    return TvSeriesModel(
      id: json['id'] as int,
      title: (json['name'] ?? json['original_name'] ?? 'Untitled').toString(),
      posterUrl: _posterUrl(json['poster_path']),
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: (json['overview'] ?? 'No overview available.').toString(),
      genres: _genres(json),
      status: (json['status'] ?? '-').toString(),
      premiered: (json['first_air_date'] ?? '-').toString(),
    );
  }

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesModel(
      id: json['id'] as int,
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      overview: json['overview'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e.toString()).toList(),
      status: json['status'] as String,
      premiered: json['premiered'] as String,
    );
  }

  factory TvSeriesModel.fromEntity(TvSeries series) {
    return TvSeriesModel(
      id: series.id,
      title: series.title,
      posterUrl: series.posterUrl,
      rating: series.rating,
      overview: series.overview,
      genres: series.genres,
      status: series.status,
      premiered: series.premiered,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'rating': rating,
      'overview': overview,
      'genres': genres,
      'status': status,
      'premiered': premiered,
    };
  }

  static String _posterUrl(dynamic posterPath) {
    if (posterPath == null || posterPath.toString().isEmpty) return '';
    return '$BASE_IMAGE_URL$posterPath';
  }

  static List<String> _genres(Map<String, dynamic> json) {
    final detailGenres = json['genres'];
    if (detailGenres is List) {
      return detailGenres
          .map((genre) {
            if (genre is Map<String, dynamic>) return genre['name'];
            return genre;
          })
          .whereType<Object>()
          .map((genre) => genre.toString())
          .where((genre) => genre.isNotEmpty)
          .toList();
    }

    final genreIds = json['genre_ids'];
    if (genreIds is List) {
      return genreIds
          .map((id) => _tvGenres[id] ?? id.toString())
          .where((genre) => genre.isNotEmpty)
          .toList();
    }

    return const <String>[];
  }

  static const Map<int, String> _tvGenres = {
    10759: 'Action & Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    10762: 'Kids',
    9648: 'Mystery',
    10763: 'News',
    10764: 'Reality',
    10765: 'Sci-Fi & Fantasy',
    10766: 'Soap',
    10767: 'Talk',
    10768: 'War & Politics',
    37: 'Western',
  };
}
