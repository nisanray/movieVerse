import '../../../media_discovery/domain/entities/media.dart';

class CalculateRecommendationsUseCase {
  /// Calculates genre scores based on watchlist and ratings
  Map<int, double> calculateGenreScores({
    required List<Media> watchlist,
    required List<dynamic> ratings,
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
      final ratingValue = rating['rating'] as num?;
      if (ratingValue == null) continue;

      final genreIds = rating['genreIds'] as List<int>?;
      if (genreIds == null) continue;

      double weight = 0;
      if (ratingValue >= 4.0) {
        weight = 3.0; // Loved it!
      } else if (ratingValue <= 2.5) {
        weight = -2.0; // Didn't like it much.
      }

      if (weight != 0) {
        for (var genreId in genreIds) {
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
    required List<dynamic> ratings,
  }) {
    // Priority: Highest Rated Recent Movie > Last Watchlist Item
    dynamic bestRatedRecent;
    try {
      bestRatedRecent = ratings.firstWhere((r) {
        final ratingValue = r['rating'] as num?;
        return ratingValue != null && ratingValue >= 4.0;
      });
    } catch (e) {
      bestRatedRecent = null;
    }

    if (bestRatedRecent != null) {
      return (
        mediaId: bestRatedRecent['mediaId'] as int?,
        mediaType: bestRatedRecent['mediaType'] as String? ?? 'movie',
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
