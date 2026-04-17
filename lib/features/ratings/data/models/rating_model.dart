import '../../domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  RatingModel({
    required super.uid,
    required super.mediaId,
    required super.mediaType,
    required super.rating,
    required super.genreIds,
    super.title,
    super.posterPath,
    required super.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'mediaId': mediaId,
      'mediaType': mediaType,
      'rating': rating,
      'genreIds': genreIds,
      'title': title,
      'posterPath': posterPath,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RatingModel.fromFirestore(Map<String, dynamic> json) {
    return RatingModel(
      uid: json['uid'] ?? '',
      mediaId: json['mediaId'] ?? 0,
      mediaType: json['mediaType'] ?? 'movie',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      genreIds: List<int>.from(json['genreIds'] ?? []),
      title: json['title'],
      posterPath: json['posterPath'],
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
