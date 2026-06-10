import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  const TvSeries({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.status,
    required this.premiered,
  });

  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final String status;
  final String premiered;

  @override
  List<Object?> get props => [
        id,
        title,
        posterUrl,
        rating,
        overview,
        genres,
        status,
        premiered,
      ];
}
