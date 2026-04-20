import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../domain/entities/media_details_entities.dart';

class CastListWidget extends StatelessWidget {
  final MediaDetails details;

  const CastListWidget({required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: details.cast.length,
            itemBuilder: (context, index) {
              final actor = details.cast[index];
              return GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.actorDiscovery,
                  arguments: {
                    'id': actor.id,
                    'name': actor.name,
                    'profileUrl': actor.profileUrl,
                  },
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 70,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                          actor.profileUrl,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actor.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actor.character,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
