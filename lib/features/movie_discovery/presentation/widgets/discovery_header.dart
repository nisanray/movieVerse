import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_discovery_controller.dart';
import '../../domain/entities/genre.dart';

class DiscoveryHeader extends GetView<MovieDiscoveryController> {
  const DiscoveryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              top: Get.statusBarHeight + 10,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Search Bar
                _buildSearchBar(),
                const SizedBox(height: 16),
                
                // Secondary Row: Segmented Toggle
                Obx(() => Row(
                  children: [
                    _buildSegmentButton('movie', 'Movies'),
                    const SizedBox(width: 16),
                    _buildSegmentButton('tv', 'TV Shows'),
                  ],
                )),
                const SizedBox(height: 16),

                // Tertiary Row: Genre Chips
                _buildGenreList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              onChanged: (value) => controller.searchQuery.value = value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search Movie Verse...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6), size: 20),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70, size: 18),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.searchQuery.value = '';
                      },
                    )
                  : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Professional Filter Icon
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white70, size: 22),
        ),
      ],
    );
  }

  Widget _buildSegmentButton(String type, String label) {
    final bool isSelected = controller.selectedMediaType.value == type;
    return GestureDetector(
      onTap: () => controller.toggleMediaType(type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 20 : 0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreList() {
    return SizedBox(
      height: 32,
      child: Obx(() {
        if (controller.genres.isEmpty) return const SizedBox.shrink();
        
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.genres.length,
          itemBuilder: (context, index) {
            final genre = controller.genres[index];
            return Obx(() {
              final isSelected = controller.selectedGenre.value.id == genre.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.selectGenre(genre),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        genre.name,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }
}
