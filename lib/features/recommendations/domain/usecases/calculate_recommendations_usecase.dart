import '../../../../core/domain/entities/media.dart';
import '../../../ratings/domain/entities/rating_entity.dart';

class CalculateRecommendationsUseCase {
  /// Calculates genre scores based on watch later, watched lists, and ratings
  Map<int, double> calculateGenreScores({
    required List<Media> watchLaterList,
    required List<Media> watchedList,
    required List<RatingEntity> ratings,
  }) {
    final Map<int, double> tempScores = {};

    // Watch later Influence (Base interest - Weight: 1.0)
    for (var media in watchLaterList) {
      for (var genreId in media.genreIds) {
        tempScores[genreId] = (tempScores[genreId] ?? 0) + 1.0;
      }
    }

    // Watched Influence (Confirmed interest - Weight: 1.5)
    for (var media in watchedList) {
      for (var genreId in media.genreIds) {
        tempScores[genreId] = (tempScores[genreId] ?? 0) + 1.5;
      }
    }

    // Ratings Influence (Strong Signal)
    for (var rating in ratings) {
      double weight = 0;
      if (rating.rating >= 4.0) {
        weight = 3.0; // Loved it!
      } else if (rating.rating <= 2.5) {
        weight = -2.0; // Didn't like it much.
      }

      if (weight != 0) {
        for (var genreId in rating.genreIds) {
          tempScores[genreId] = (tempScores[genreId] ?? 0) + weight;
        }
      }
    }

    return tempScores;
  }

  /// Gets top genres from genre scores. 
  /// If no positive interests are found, returns a set of default "trending" genres.
  List<int> getTopGenres(Map<int, double> genreScores, {int limit = 3}) {
    final sortedGenres = genreScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top = sortedGenres
        .where((e) => e.value > 0)
        .take(limit)
        .map((e) => e.key)
        .toList();

    // Fallback to broadly popular genres (Action, Comedy, Drama) if profile is empty
    if (top.isEmpty) {
      return [28, 35, 18];
    }

    return top;
  }

  /// Determines the best base media for recommendations
  ({int? mediaId, String mediaType, String title}) determineBestBaseMedia({
    required List<Media> watchLaterList,
    required List<Media> watchedList,
    required List<RatingEntity> ratings,
  }) {
    // Priority: Highest Rated Recent Movie > Last Watched Item > Last Watch Later Item
    RatingEntity? bestRatedRecent;
    try {
      bestRatedRecent = ratings.firstWhere((r) => r.rating >= 4.0);
    } catch (e) {
      bestRatedRecent = null;
    }

    if (bestRatedRecent != null) {
      return (
        mediaId: bestRatedRecent.mediaId,
        mediaType: bestRatedRecent.mediaType,
        title: "Highly Rated",
      );
    } else if (watchedList.isNotEmpty) {
      final lastMedia = watchedList.last;
      return (
        mediaId: lastMedia.id,
        mediaType: lastMedia.isMovie ? 'movie' : 'tv',
        title: lastMedia.title,
      );
    } else if (watchLaterList.isNotEmpty) {
      final lastMedia = watchLaterList.last;
      return (
        mediaId: lastMedia.id,
        mediaType: lastMedia.isMovie ? 'movie' : 'tv',
        title: lastMedia.title,
      );
    }

    return (mediaId: null, mediaType: 'movie', title: '');
  }
}

