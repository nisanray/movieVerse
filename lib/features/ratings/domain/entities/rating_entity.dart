class RatingEntity {
  final String uid;
  final int mediaId;
  final String mediaType;
  final double rating;
  final List<int> genreIds;
  final String? title;
  final String? posterPath;
  final DateTime updatedAt;

  RatingEntity({
    required this.uid,
    required this.mediaId,
    required this.mediaType,
    required this.rating,
    required this.genreIds,
    this.title,
    this.posterPath,
    required this.updatedAt,
  });
}
