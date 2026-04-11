/// [Media] is a unified entity representing both Movies and TV Shows.
/// It abstracts the differences in field names from the TMDB API.
class Media {
  final int id;
  final String title; // Maps to 'title' for movies and 'name' for TV shows.
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate; // Maps to 'release_date' for movies and 'first_air_date' for TV shows.
  final bool isMovie;

  Media({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.isMovie,
  });

  /// Helper to get the full formatted poster URL.
  String get fullPosterPath => posterPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : 'https://via.placeholder.com/500x750?text=No+Image';

  /// Helper to get the full formatted backdrop URL.
  String get fullBackdropPath => backdropPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/original$backdropPath' 
      : 'https://via.placeholder.com/1920x1080?text=No+Image';
}
