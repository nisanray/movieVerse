import '../../domain/entities/media.dart';

/// [MediaModel] is the data model for the TMDB Media entry (Movies or TV Shows).
/// It handles the logic of parsing different field names (e.g., 'title' vs 'name')
/// and different date keys (e.g., 'release_date' vs 'first_air_date').
class MediaModel extends Media {
  MediaModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.isMovie,
  });

  /// Factory constructor to create a [MediaModel] from TMDB JSON.
  factory MediaModel.fromJson(Map<String, dynamic> json) {
    // If 'media_type' is provided (e.g., from multi-search), use it.
    // Otherwise, fallback to checking for 'title' vs 'name'.
    final String? mediaType = json['media_type'];
    final bool isMovieResult = mediaType != null 
        ? mediaType == 'movie' 
        : json.containsKey('title');
    
    return MediaModel(
      id: json['id'] ?? 0,
      title: (isMovieResult ? json['title'] : json['name']) ?? 'Unknown Title',
      overview: json['overview'] ?? 'No overview available.',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: (isMovieResult ? json['release_date'] : json['first_air_date']) ?? '',
      isMovie: isMovieResult,
    );
  }

  /// Converts the [MediaModel] back into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (isMovie) 'title': title else 'name': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      if (isMovie) 'release_date': releaseDate else 'first_air_date': releaseDate,
      'is_movie': isMovie,
    };
  }
}
