import '../../domain/entities/movie_details_entities.dart';
import 'movie_details_submodels.dart';

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    required super.cast,
    required super.videos,
  });

  factory MovieDetailsModel.fromJson(
    Map<String, dynamic> json, {
    List<CastModel> cast = const [],
    List<VideoModel> videos = const [],
  }) {
    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List?)
              ?.map((g) => g['name'] as String)
              .toList() ??
          [],
      cast: cast,
      videos: videos,
    );
  }
}
