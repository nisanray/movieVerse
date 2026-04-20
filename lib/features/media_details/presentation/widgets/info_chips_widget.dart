import 'package:flutter/material.dart';
import '../../domain/entities/media_details_entities.dart';

class InfoChipsWidget extends StatelessWidget {
  final MediaDetails details;

  const InfoChipsWidget({required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (details.isMovie)
            InfoChip(label: '${details.runtime} min')
          else ...[
            InfoChip(label: '${details.numberOfSeasons} Seasons'),
            InfoChip(label: '${details.numberOfEpisodes} Episodes'),
          ],
          ...details.genres.map((g) => InfoChip(label: g)),
        ],
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final String label;

  const InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
