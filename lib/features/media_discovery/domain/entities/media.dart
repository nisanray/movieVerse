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
  final List<int> genreIds;

  Media({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.isMovie,
    this.genreIds = const [],
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'isMovie': isMovie,
      'genreIds': genreIds,
      'addedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Create from Map (Firestore)
  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['posterPath'] ?? '',
      backdropPath: map['backdropPath'] ?? '',
      voteAverage: (map['voteAverage'] ?? 0).toDouble(),
      releaseDate: map['releaseDate'] ?? '',
      isMovie: map['isMovie'] ?? true,
      genreIds: List<int>.from(map['genreIds'] ?? []),
    );
  }

  /// Helper to get the full formatted poster URL.
  String get fullPosterPath => posterPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : 'https://via.placeholder.com/500x750?text=No+Image';

  /// Helper to get the full formatted backdrop URL.
  String get fullBackdropPath => backdropPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/original$backdropPath' 
      : 'https://via.placeholder.com/1920x1080?text=No+Image';
}
