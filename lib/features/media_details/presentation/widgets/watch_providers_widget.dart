import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/media_details_entities.dart';

class WatchProvidersWidget extends StatelessWidget {
  final MediaDetails details;

  const WatchProvidersWidget({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    if (details.watchProviders == null || details.watchProviders!.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasStream = details.watchProviders!.containsKey('flatrate');
    final hasRent = details.watchProviders!.containsKey('rent');
    final hasBuy = details.watchProviders!.containsKey('buy');

    if (!hasStream && !hasRent && !hasBuy) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where to Watch',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        if (hasStream) _buildProviderSection('Stream', details.watchProviders!['flatrate']!),
        if (hasRent) ...[
          const SizedBox(height: 16),
          _buildProviderSection('Rent', details.watchProviders!['rent']!),
        ],
        if (hasBuy) ...[
          const SizedBox(height: 16),
          _buildProviderSection('Buy', details.watchProviders!['buy']!),
        ],
      ],
    );
  }

  Widget _buildProviderSection(String title, List<WatchProvider> providers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white60,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return _ProviderIcon(provider: provider);
            },
          ),
        ),
      ],
    );
  }
}

class _ProviderIcon extends StatelessWidget {
  final WatchProvider provider;

  const _ProviderIcon({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: CachedNetworkImage(
          imageUrl: provider.logoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.white.withOpacity(0.05),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white24),
        ),
      ),
    );
  }
}
