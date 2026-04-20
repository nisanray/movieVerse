import '../../../media_discovery/domain/entities/media.dart';
import '../../../ratings/domain/entities/rating_entity.dart';

class CalculateRecommendationsUseCase {
  /// Calculates genre scores based on watchlist and ratings
  Map<int, double> calculateGenreScores({
    required List<Media> watchlist,
    required List<RatingEntity> ratings,
  }) {
    final Map<int, double> tempScores = {};

    // Watchlist Influence (Base interest)
    for (var media in watchlist) {
      for (var genreId in media.genreIds) {
        tempScores[genreId] = (tempScores[genreId] ?? 0) + 1.0;
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

  /// Gets top genres from genre scores
  List<int> getTopGenres(Map<int, double> genreScores, {int limit = 3}) {
    final sortedGenres = genreScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedGenres
        .where((e) => e.value > 0) // Only positive interests
        .take(limit)
        .map((e) => e.key)
        .toList();
  }

  /// Determines the best base media for recommendations
  ({int? mediaId, String mediaType, String title}) determineBestBaseMedia({
    required List<Media> watchlist,
    required List<RatingEntity> ratings,
  }) {
    // Priority: Highest Rated Recent Movie > Last Watchlist Item
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
    } else if (watchlist.isNotEmpty) {
      final lastMedia = watchlist.last;
      return (
        mediaId: lastMedia.id,
        mediaType: lastMedia.isMovie ? 'movie' : 'tv',
        title: lastMedia.title,
      );
    }

    return (mediaId: null, mediaType: 'movie', title: '');
  }
}
