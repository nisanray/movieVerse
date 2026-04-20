import '../../../media_discovery/domain/entities/media.dart';

class MatchPercentageCalculator {
  /// Calculates a personalized match percentage (0-100) for a given media item.
  int calculateMatchPercentage(Media media, Map<int, double> genreScores) {
    if (genreScores.isEmpty) return 70; // Default "discovery" match score

    double totalScore = 0;
    int matches = 0;

    for (var genreId in media.genreIds) {
      if (genreScores.containsKey(genreId)) {
        totalScore += genreScores[genreId]!;
        matches++;
      }
    }

    if (matches == 0) return 65; // Neutral match for unfamiliar genres

    // Normalize score. Average genre score of 3.0 (5-star signal) = 100%
    // Average score of 1.0 (Watch later signal) = 85%
    // Average score of 0.0 = 50%
    double avgScore = totalScore / matches;
    
    // Simple linear mapping: 0 -> 70, 3 -> 98
    // Note: We use 98 as max to feel more "calculated" than a flat 100
    int percentage = (70 + (avgScore * 9.3)).clamp(40, 98).toInt();
    
    return percentage;
  }
}
