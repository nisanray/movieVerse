import '../../domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  RatingModel({
    required super.uid,
    required super.mediaId,
    required super.mediaType,
    required super.rating,
    required super.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'mediaId': mediaId,
      'mediaType': mediaType,
      'rating': rating,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RatingModel.fromFirestore(Map<String, dynamic> json) {
    return RatingModel(
      uid: json['uid'] ?? '',
      mediaId: json['mediaId'] ?? 0,
      mediaType: json['mediaType'] ?? 'movie',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
