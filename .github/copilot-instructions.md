# AI Agent Instructions for قانون (Qanon) Project

## Project Overview
قانون (Qanon) is a Flutter-based legal advisor application for Jordanian law, powered by Google's Gemini AI. The app provides legal consultations and document management in Arabic.

## Core Architecture

### Key Components
1. **Authentication System** (`lib/services/auth_service.dart`, `lib/providers/auth_provider.dart`)
   - Firebase Auth with fallback mode
   - User state management via Provider pattern
   - See `AUTH_IMPLEMENTATION.md` for details

2. **UI Structure**
   - Material Design 3 with Arabic RTL support
   - Consistent green theme (`Color(0xFF1B5E20)`)
   - All UI text in Arabic

3. **Services Layer** (`lib/services/`)
   - AI Service (Gemini AI integration)
   - Contract Service (Legal document management)
   - Download Service (File handling)

## Development Workflows

### Setup & Running
```bash
flutter pub get
flutter run
```

### Firebase Configuration
1. Use existing config in `firebase_options.dart`
2. For production: Replace API key in `lib/services/ai_service.dart`

### Critical Patterns

1. **Authentication**
   ```dart
   final authProvider = context.read<AuthProvider>();
   if (authProvider.isAuthenticated) {
     // Protected features here
   }
   ```

2. **Error Handling**
   - All user-facing errors in Arabic
   - Use try-catch with AuthResult pattern

3. **File Operations**
   - Use DownloadService for file handling
   - Handle permissions via permission_handler

## Project Structure
- `lib/screens/` - All UI screens
- `lib/services/` - Core business logic
- `lib/providers/` - State management
- `lib/models/` - Data models
- `lib/widgets/` - Reusable components

## Common Tasks

### Adding New Features
1. Place screens in `lib/screens/`
2. Update routes in `lib/main.dart`
3. Follow Arabic localization pattern
4. Implement auth checks where needed

### Testing
- Widget tests in `test/widget_test.dart`
- Run tests: `flutter test`

## Integration Points
1. **Firebase Services**
   - Authentication
   - Firestore for user data
   - Storage for documents

2. **Google Gemini AI**
   - Legal consultation features
   - API key management

## Known Conventions
1. Arabic-first UI design
2. Material Design 3 components
3. Provider pattern for state
4. Error messages in Arabic
5. Authenticated routes protection
