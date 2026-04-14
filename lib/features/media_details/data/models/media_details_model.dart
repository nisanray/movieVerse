import '../../domain/entities/media_details_entities.dart';
import 'media_details_submodels.dart';

class MediaDetailsModel extends MediaDetails {
  MediaDetailsModel({
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
    required super.isMovie,
    super.numberOfSeasons,
    super.numberOfEpisodes,
    super.tagline,
    super.status,
  });

  factory MediaDetailsModel.fromJson(
    Map<String, dynamic> json, {
    List<CastModel> cast = const [],
    List<VideoModel> videos = const [],
    required bool isMovie,
  }) {
    return MediaDetailsModel(
      id: json['id'] ?? 0,
      title: (isMovie ? json['title'] : json['name']) ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: (isMovie ? json['release_date'] : json['first_air_date']) ?? '',
      runtime: isMovie ? (json['runtime'] ?? 0) : (json['episode_run_time'] != null && (json['episode_run_time'] as List).isNotEmpty ? json['episode_run_time'][0] : 0),
      genres: (json['genres'] as List?)
              ?.map((g) => g['name'] as String)
              .toList() ??
          [],
      cast: cast,
      videos: videos,
      isMovie: isMovie,
      numberOfSeasons: json['number_of_seasons'],
      numberOfEpisodes: json['number_of_episodes'],
      tagline: json['tagline'],
      status: json['status'],
    );
  }
}
