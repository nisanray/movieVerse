# FEATURE REGISTRY

This registry tracks the status and priority of all features in **Movie Verse**.

## 🎬 Core Discovery Experience
| Feature | Priority | Complexity | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Movie Discovery** | P0 | Low | ✅ Active | Trending, Popular, Now Playing. |
| **TV Show Discovery** | P0 | Medium | ✅ Active | Integration with TMDB TV endpoints. |
| **Search (Multi)** | P0 | Low | ✅ Active | Search for movies and TV shows. |
| **Genre Filtering** | P1 | Low | ✅ Active | Categorize by genre via Header & Drawer. |
| **Country Filtering** | P1 | Medium | ✅ Active | Dynamic country filtering in Drawer. |
| **Advanced Sorting** | P1 | Low | ✅ Active | Sort by rating, release date, etc. |

## 🧠 Personalization & Intelligence
| Feature | Priority | Complexity | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Authentication** | P0 | Medium | ✅ Active | Firebase Auth integration. |
| **Watchlist** | P0 | Low | ✅ Active | Real-time Firestore persistence. |
| **AI Movie Scout** | P2 | High | ✅ Active | Hugging Face Mistral-7B integration. |
| **Smart Recs** | P1 | Medium | ✅ Active | Genre-based scoring, Match %, Weighted preferences. |
| **Ratings System** | P0 | Medium | ✅ Active | 5-star half-precision, Firestore persistence. |

## 🎨 Aesthetics & UI
| Feature | Priority | Complexity | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Dynamic Themes** | P2 | Medium | 💡 Ideation | Colors adapt to movie poster. |
| **Animations** | P1 | Low | ✅ Active | Flutter Animate / Animate Do. |
| **Glassmorphism** | P1 | Medium | ✅ Active | Premium UI components. |

## 🎭 Immersive Experience (Phase 3)
| Feature | Priority | Complexity | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Enhanced Trailer Player** | P1 | Medium | ✅ Active | Full-screen, PiP, custom controls, related videos, multi-video support. |
| **Social Sharing** | P1 | High | 🏗️ In-Progress | Placeholder exists. Needs: Share to social, friend recs, comments. |
| **Offline Downloads** | P2 | High | ❄️ Frozen | Placeholder exists. Needs: Download management, offline viewing. |
| **Local Caching** | P2 | Medium | 💡 Ideation | Cache API responses, reduce redundant calls. |

---
**Status Legend:**
- 💡 **Ideation**: Planned/Proposed.
- ❄️ **Frozen**: Delayed until foundations are ready.
- 🏗️ **In-Progress**: Currently being developed.
- ✅ **Active**: Fully implemented and tested.
