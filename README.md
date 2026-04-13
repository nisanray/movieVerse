# 🎬 Movie Verse

**Movie Verse** is a high-performance, cinematic movie discovery platform built with Flutter. It combines real-time data from TMDB with a premium glassmorphic UI to provide an immersive browsing experience.

---

## 🌟 Key Features

- **Premium Discovery**: Explore trending, popular, and top-rated movies/TV shows with a high-impact, glassmorphic UI.
- **Firebase Authentication**: Secure user accounts with Email/Password and Google Sign-In integration.
- **Advanced Filtering**: Discover content by Genre, Country, Year, and Rating using a unified filtering engine.
- **Unified Media Search**: Fast, real-time search across the entire TMDB database.
- **Clean Architecture**: Built using a modular GetX-based architecture for scalability and maintainability.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend/Auth**: Firebase (Core, Auth)
- **State Management**: GetX
- **Networking**: Dio (TMDB API v3)
- **Local Database**: Hive
- **Animations**: Flutter Animate / Animate Do
- **Architecture**: Clean Architecture (Data, Domain, Presentation)

---

## 📘 Documentation

To learn more about the project's strategy and technical requirements, explore the dedicated documentation files:

| Document | Description |
| :--- | :--- |
| [**Product Requirements (PRD)**](docs/PRD.md) | High-level goals, target audience, and feature roadmap. |
| [**Technical Specification (SRS)**](docs/SRS.md) | Technical architecture, data models, and functional requirements. |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- TMDB API Key

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nisanray/movieVerse.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Add your TMDB API Key in `lib/core/api/api_client.dart`.

4. Run the app:
   ```bash
   flutter run
   ```

---

## 📸 Screenshots

*(Add screenshots here after implementation)*

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
