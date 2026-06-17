# JainQuest

A mobile app for learning Jain philosophy through short, gamified lessons. Built with Flutter; shares a backend with the JainQuest web app.

## What it does

JainQuest teaches Jain concepts to teenagers in bite-sized lessons laid out on a path. Lessons mix warm-up questions, text cards, short videos, explanations, and multiple-choice or true/false quizzes, and feed a gamification system: XP and levels, a five-heart lives system with time-based regeneration, daily streaks, and badges. There's also a spaced-repetition practice mode, a community forum, a leaderboard, and local notifications for streaks and reminders. The app is available in English, Hindi, and Gujarati.

Accounts and progress sync through Firebase. An AI "Guru" chat answers questions about Jain concepts, with a built-in offline fallback for core topics so it still works without a network.

## Built with

- Flutter / Dart (Dart SDK >= 3.2)
- Riverpod for state management
- Firebase Auth, Cloud Firestore, and Firebase Storage
- Google Generative AI (Gemini) for the Guru chat

## Running it

```
flutter pub get
flutter run
```

The Gemini API key is not stored in code — it's read at runtime from Firestore (`app_config/ai`). `firebase_options.dart` holds the standard Firebase client identifiers, which are protected by the Firestore and Storage security rules.

Parts of this project were built with AI coding assistance.
