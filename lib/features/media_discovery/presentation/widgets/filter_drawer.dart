import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/media_discovery_controller.dart';

class FilterDrawer extends GetView<MediaDiscoveryController> {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.75,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Glassmorphic Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(64),
                border: Border(
                  left: BorderSide(color: Colors.white.withAlpha(26)),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Search by Year'),
                  const SizedBox(height: 16),
                  _buildYearDropdown(),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Origin Country'),
                  const SizedBox(height: 16),
                  _buildCountryDropdown(),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Genre'),
                  const SizedBox(height: 16),
                  _buildGenreDropdown(),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Sort By'),
                  const SizedBox(height: 16),
                  _buildSortDropdown(),
                  const SizedBox(height: 40),
                  _buildActionButtons(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discovery\nFilters',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(
      () => _buildGlassDropdown<int>(
        value: controller.selectedYear.value,
        hint: 'All Years',
        items: controller.availableYears.map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(
              year == 0 ? 'All Years' : year.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) => controller.selectedYear.value = value ?? 0,
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return Obx(() {
      if (controller.genres.isEmpty) {
        return _buildGlassDropdown<int>(
          value: 0,
          hint: 'Loading...',
          items: [
            const DropdownMenuItem<int>(
              value: 0,
              child: Text(
                'Loading...',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
          onChanged: (_) {},
        );
      }

      return _buildGlassDropdown<int>(
        value: controller.selectedGenre.value.id,
        hint: 'All Genres',
        items: controller.genres.map((genre) {
          return DropdownMenuItem<int>(
            value: genre.id,
            child: Text(
              genre.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (id) {
          final genre = controller.genres.firstWhere((g) => g.id == id);
          controller.selectedGenre.value = genre;
        },
      );
    });
  }

  Widget _buildCountryDropdown() {
    return Obx(() {
      final countryList = controller.countries.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final items = [
        const DropdownMenuItem<String>(
          value: '',
          child: Text(
            'All Countries',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        ...countryList.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(
              entry.value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }),
      ];

      // Safe check for value existence in items
      final String currentValue = controller.selectedCountryCode.value;
      final bool valueInItems = items.any((item) => item.value == currentValue);

      return _buildGlassDropdown<String>(
        value: valueInItems ? currentValue : '',
        hint: 'All Countries',
        items: items,
        onChanged: (value) =>
            controller.selectedCountryCode.value = value ?? '',
      );
    });
  }

  Widget _buildSortDropdown() {
    final sortOptions = {
      'popularity.desc': 'Popularity',
      'vote_average.desc': 'Top Rated',
      'primary_release_date.desc': 'Newest First',
      'primary_release_date.asc': 'Oldest First',
    };

    return Obx(
      () => _buildGlassDropdown<String>(
        value: controller.selectedSortBy.value,
        hint: 'Popularity',
        items: sortOptions.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(
              entry.value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) =>
            controller.selectedSortBy.value = value ?? 'popularity.desc',
      ),
    );
  }

  Widget _buildGlassDropdown<T>({
    required T value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: Colors.black.withAlpha(230),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          isExpanded: true,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.fetchFilteredMedia();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'APPLY FILTERS',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              controller.resetFilters();
              Get.back();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white70,
            ),
            child: const Text('Reset All'),
          ),
        ),
      ],
    );
  }
}
