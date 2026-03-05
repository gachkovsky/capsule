# Capsule — Time Capsule App

## Concept
App for sending time-locked messages to yourself or friends.
Messages are sealed until a chosen date, then unlocked with push notification.

## Stack
- Flutter 3.41.3
- State management: Riverpod 3
- Navigation: go_router
- Backend: Supabase
- DI: get_it
- Architecture: Feature-First

## Architecture: Feature-First
lib/
  features/
    capsules/
      data/
      domain/
      presentation/
    auth/
      data/
      domain/
      presentation/
  core/
    theme/
    router/
    di/
  shared/
    widgets/

## Code Style
- Use hooks (flutter_hooks + hooks_riverpod)
- Prefer ConsumerWidget over StatefulWidget
- All strings in English in code, UI can be Russian
- No print() — use debugPrint()

## Commands
- Run: flutter run
- Build APK: flutter build apk --release
- Format: dart format .
- Analyze: flutter analyze

## Device
- ASUS Zenfone AI2202, Android 14, USB debug