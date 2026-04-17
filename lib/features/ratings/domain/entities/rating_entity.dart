class RatingEntity {
  final String uid;
  final int mediaId;
  final String mediaType;
  final double rating;
  final DateTime updatedAt;

  RatingEntity({
    required this.uid,
    required this.mediaId,
    required this.mediaType,
    required this.rating,
    required this.updatedAt,
  });
}
