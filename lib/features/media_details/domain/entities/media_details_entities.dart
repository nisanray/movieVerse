import '../../../../core/domain/entities/media.dart';

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

class WatchProvider {
  final int providerId;
  final String providerName;
  final String? logoPath;
  final int displayPriority;

  WatchProvider({
    required this.providerId,
    required this.providerName,
    this.logoPath,
    required this.displayPriority,
  });

  String get logoUrl => logoPath != null
      ? 'https://image.tmdb.org/t/p/w200$logoPath'
      : 'https://ui-avatars.com/api/?name=$providerName&background=random';
}

class MediaDetails {
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
  final List<int> genreIds; // Added to support recommendations
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final String? tagline;
  final String? status;
  final Map<String, List<WatchProvider>>? watchProviders;

  MediaDetails({
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
    this.genreIds = const [],
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.tagline,
    this.status,
    this.watchProviders,
  });

  String get fullPosterPath => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropPath => 'https://image.tmdb.org/t/p/original$backdropPath';

  /// Converts detailed model back to simple Media entity for watch later persistence.
  Media toMedia() {
    return Media(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      isMovie: isMovie,
      genreIds: genreIds,
    );
  }
}

