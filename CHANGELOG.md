# CHANGELOG

All notable changes to the **Movie Verse** project will be documented in this file.

## [Unreleased]

### 🏗️ In Progress
- **Social Sharing**: Share to social media, friend recommendations, comments.

### ✅ Added - Phase 3: Immersive Experience [IN PROGRESS]
- **Enhanced Trailer Player**: Full-screen mode, picture-in-picture toggle, custom playback controls (replay/forward 10s), related videos section with horizontal scrollable list, multiple video support.

### ✅ Added - Phase 2: Intelligent Discovery [COMPLETED]
- **For You Recommendations Dashboard**: Personalized picks and similar content sections with genre-based scoring.
- **Advanced Genre Preference Engine**: Weighted genre scoring from watchlist and ratings, match percentage calculations.
- **Global Bottom Navigation**: 4-tab navigation (Discovery, For You, Library, Profile) with floating pill design.
- **AI Movie Scout**: Hugging Face Mistral-7B integration for conversational discovery with deep space aesthetic.
- **Internal Rating System**: 5-star half-precision rating system with Firestore persistence and genre tracking.
- **Smart Recommendations Upgrade**: Combined watchlist signals with user ratings for accurate personalization.
- **Expandable Recommendation Grid**: Top 4 summary view with "See All" navigation to dedicated list pages.
- **UI Standardization**: Symmetric discovery wall with flexible MediaCard components.
- **Premium Header Masks**: Shader mask integration for elegant title scrolling with marquee support.

### ✅ Added - Phase 1: Cloud Synergy [COMPLETED]
- **Profile Picture Management**: Fully implemented dynamic avatar uploads to Firebase Storage with real-time UI updates.
- **My Library Hub**: Consolidated User Watchlist and Custom Ratings into a premium, unified aesthetic, fully synchronized with Firestore.
- **Firebase Authentication Integration**: Implemented robust Email/Password and Google Sign-In using Firebase Auth with secure GetX-based state management.
- **Unified Media Discovery**: Transitioned from separate Movie/TV logic to a high-performance, unified `Media` entity with cross-platform filtering support.
- **Advanced Filtering Engine**: Added support for Genre, Country, Year, and Sort-based discovery via a glassmorphic Filter Drawer.
- **Configuration Services**: Automated fetching of Countries and Genres from TMDB with real-time syncing.

### 🛠️ Fixed
- **Nuget Build Error**: Added `nuget.exe` to `dev_tools/` to resolve `flutter_inappwebview_windows` dependency issues.
- **Movie Details Navigation**: Fixed Similar Content taps not navigating to the selected title (handles GetX duplicate-route prevention and refreshes details state correctly).
