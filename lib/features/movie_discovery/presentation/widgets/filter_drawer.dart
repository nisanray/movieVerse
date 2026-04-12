import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/movie_discovery_controller.dart';

class FilterDrawer extends GetView<MovieDiscoveryController> {
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
                color: Colors.black.withOpacity(0.8),
                border: Border(
                  left: BorderSide(color: Colors.white.withOpacity(0.1)),
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
                  _buildSectionTitle('Search by Year'),
                  const SizedBox(height: 16),
                  _buildYearDropdown(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Origin Country'),
                  const SizedBox(height: 16),
                  _buildCountryDropdown(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Sort By'),
                  const SizedBox(height: 16),
                  _buildSortDropdown(),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
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
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.red,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(() => _buildGlassDropdown<int>(
      value: controller.selectedYear.value,
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
    ));
  }


  Widget _buildCountryDropdown() {
    final popularCountries = {
      '': 'All Countries',
      'US': 'United States',
      'IN': 'India',
      'GB': 'United Kingdom',
      'KR': 'South Korea',
      'JP': 'Japan',
      'FR': 'France',
      'ES': 'Spain',
      'IT': 'Italy',
      'HK': 'Hong Kong',
      'CN': 'China',
      'BR': 'Brazil',
      'RU': 'Russia',
    };

    return Obx(() => _buildGlassDropdown<String>(
      value: controller.selectedCountryCode.value,
      items: popularCountries.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (value) => controller.selectedCountryCode.value = value ?? '',
    ));
  }

  Widget _buildSortDropdown() {
    final sortOptions = {
      'popularity.desc': 'Popularity',
      'vote_average.desc': 'Top Rated',
      'primary_release_date.desc': 'Newest First',
      'primary_release_date.asc': 'Oldest First',
    };

    return Obx(() => _buildGlassDropdown<String>(
      value: controller.selectedSortBy.value,
      items: sortOptions.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(
            entry.value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (value) => controller.selectedSortBy.value = value ?? 'popularity.desc',
    ));
  }

  Widget _buildGlassDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: Colors.grey[900],
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.red),
          isExpanded: true,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
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
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
