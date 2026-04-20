# 🎬 Movie Verse Development Roadmap

This roadmap outlines the strategic phases for evolving Movie Verse into a premium cinematic ecosystem.

## 🚀 Phase 1: Authentication & Sync (High Priority)
- [x] **Firebase Integration**: Set up Firebase project and link with Flutter app.
- [x] **Auth Flow**: Implement Email/Google login using `lib/features/auth`.
- [x] **User Persistence**: Store user preferences and watchlist in Firestore.
- [x] **Profile Management**: Update user metadata and profile pictures.

## 🧠 Phase 2: Intelligence & Personalization
- [x] **AI Movie Scout**: Integrated Hugging Face Mistral-7B for conversational discovery.
- [x] **Chat Persistence**: Implemented local history storage using Hive.
- [x] **Markdown Rendering**: Added rich text support for AI responses.
- [x] **Smart Recommendations**: Implemented genre-based scoring, match percentages, personalized picks, similar content.
- [x] **Bottom Navigation**: 4-tab navigation (Discovery, For You, Library, Profile).
- [ ] **Dynamic Theming**: Use `palette_generator` to adapt UI colors to movie posters.

## 📺 Phase 3: Content Enrichment
- [ ] **Streaming Providers**: Add "Where to Watch" section in `MovieDetails`.
- [x] **TV Show Support**: Extended discovery logic to include TV Series (unified Media entity).
- [ ] **Offline Viewing**: Complete the `lib/features/downloads` module for offline access.
- [ ] **Enhanced Trailer Player**: Full-screen mode, playback quality options, picture-in-picture, related trailers.

## 🤝 Phase 4: Social & Community
- [ ] **Social Sharing**: Share to social media, friend recommendations.
- [ ] **Shared Watchlists**: Allow users to create and share lists with friends.
- [x] **Interactive Reviews**: 5-star rating system with half-precision, Firestore persistence.
- [ ] **Comments**: Add commenting system for media.
- [ ] **Cast Connections**: Visualize actor filmography connections.

---
*Note: This file is for local development tracking and is ignored by git.*
