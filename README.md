# JainQuest

**Gamified Jain Learning for Teens** - A free, calm, and non-preachy Flutter app.

## Overview

JainQuest is a Duolingo-style educational app that teaches Jain philosophy to teenagers (13-19) through engaging, bite-sized lessons. The app focuses on practical principles like non-violence (Ahimsa), self-improvement, and mindfulness without being preachy or religious.

## Features

### Learning
- **Duolingo-style Path**: Zig-zag lesson path with unlocking progression
- **Micro-learning**: 7 minutes max per lesson, 6 screens max
- **Multiple Screen Types**: Warm-up questions, text cards, video references, explanations, quizzes
- **Quiz Formats**: Multiple choice, true/false, (future: match pairs, reorder)

### Gamification
- **XP System**: Earn XP for correct answers and lesson completion
- **Levels**: Level up as you accumulate XP
- **Hearts System**: 5 hearts max, lose on wrong answers, refill over time or via practice
- **Streaks**: Daily streak tracking with freeze protection
- **Badges**: Unlock badges for completing lessons

### Practice
- **Review Mode**: Spaced repetition of questions from completed lessons
- **Target Weak Spots**: Focus on previously incorrect questions
- **Heart Refill**: Complete practice to earn hearts back

### Notifications
- **Learning Reminders**: Customizable daily reminders
- **Streak Alerts**: Warnings when streak is at risk
- **Ahimsa Prompts**: Mindful practice check-ins
- **Reflection Prompts**: Evening reflection reminders
- **Quiet Hours**: Configurable notification-free periods

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── theme/
│   │   └── app_theme.dart    # Material 3 theme with custom colors
│   ├── models/
│   │   ├── lesson_models.dart    # Lesson, Quiz, Choice models
│   │   ├── user_models.dart      # User, Progress, Notification models
│   │   └── user_models.g.dart    # Hive type adapters
│   ├── services/
│   │   ├── storage_service.dart      # Hive persistence
│   │   └── notification_service.dart # Local notifications
│   ├── providers/
│   │   └── app_providers.dart    # Riverpod state management
│   ├── content/
│   │   └── unit1_content.dart    # Unit 1: Foundations of Jainism
│   └── widgets/
│       └── common_widgets.dart   # Reusable UI components
├── features/
│   ├── home/
│   │   └── presentation/
│   │       └── home_screen.dart
│   ├── path/
│   │   └── presentation/
│   │       └── unit_path_screen.dart
│   ├── lesson_runner/
│   │   └── presentation/
│   │       ├── lesson_runner_screen.dart
│   │       └── screens/
│   │           ├── question_intro_screen.dart
│   │           ├── short_text_screen.dart
│   │           ├── youtube_video_screen.dart
│   │           ├── explanation_screen.dart
│   │           ├── quiz_screen.dart
│   │           └── lesson_complete_screen.dart
│   ├── practice/
│   │   └── presentation/
│   │       ├── practice_hub_screen.dart
│   │       └── practice_session_screen.dart
│   ├── profile/
│   │   └── presentation/
│   │       └── profile_screen.dart
│   └── settings/
│       └── presentation/
│           └── settings_screen.dart
```

## Design System

### Colors
- **Primary**: #D97757 (Warm terracotta)
- **Secondary**: #FBBF77 (Soft gold)
- **Background**: #F7F6F3 (Warm white)
- **Success**: #16A34A (Green)
- **Danger**: #DC2626 (Red)

### Typography
- Font: Nunito (Google Fonts)
- Title weight: 800 (Extra Bold)
- Body line height: 1.45

### Components
- Card radius: 16px
- Pill radius: 999px (fully rounded)
- Button radius: 12px

## Unit 1 Content: Foundations of Jainism

1. **Lesson 1.1**: What is Jainism?
   - Jina, Jinendra, Tirthankara
   - Core purpose and Ahimsa

2. **Lesson 1.2**: Jiva and Ajiva
   - Living vs non-living
   - 1-5 senses classification

3. **Lesson 1.3**: The Soul (Jiva)
   - Eternal nature of the soul
   - Karma as covering

4. **Lesson 1.4**: Fundamentals of Karma
   - Karma as pudgal (matter)
   - Emotion as binding agent

## Getting Started

### Prerequisites
- Flutter SDK 3.2.0+
- Dart SDK 3.2.0+
- Android Studio / Xcode

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/jainquest.git
cd jainquest

# Install dependencies
flutter pub get

# Run build runner for Hive adapters (if needed)
flutter pub run build_runner build

# Run the app
flutter run
```

### Build for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Dependencies

- **State Management**: flutter_riverpod
- **Local Storage**: hive_flutter, shared_preferences
- **Animations**: lottie, confetti, flutter_animate
- **Notifications**: flutter_local_notifications, timezone
- **UI**: google_fonts, flutter_svg
- **External Links**: url_launcher

## Content Guidelines

### Tone
- Modern, friendly, simple
- Respectful, not religiously preachy
- No guilt, fear, or superiority language
- Focus on principles and self-improvement

### Constraints
- Max 7 minutes per lesson
- Max 6 screens per lesson
- No emojis in UI text
- No payment walls

## Future Roadmap

- [ ] Unit 2: The Five Vows
- [ ] Unit 3: Jain Ethics in Daily Life
- [ ] Lottie mascot animations
- [ ] Cloud sync with Firebase
- [ ] Leaderboards
- [ ] Social features
- [ ] More quiz formats (match pairs, reorder)
- [ ] Audio narration

## License

MIT License - Free for personal and educational use.

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

---

Built with love using Flutter.
