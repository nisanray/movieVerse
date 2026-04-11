class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  String get profileUrl => profilePath != null 
    ? 'https://image.tmdb.org/t/p/w200$profilePath'
    : 'https://ui-avatars.com/api/?name=$name&background=random';
}

class Video {
  final String id;
  final String name;
  final String key;
  final String site;
  final String type;

  Video({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
  final List<Cast> cast;
  final List<Video> videos;
  final bool isMovie;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final String? tagline;
  final String? status;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.cast,
    required this.videos,
    required this.isMovie,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.tagline,
    this.status,
  });

  String get fullPosterPath => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropPath => 'https://image.tmdb.org/t/p/original$backdropPath';
}
