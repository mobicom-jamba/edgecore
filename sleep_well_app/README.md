# Sleep Well - Flutter Sleep App MVP

A privacy-first sleep app designed to help you build healthy bedtime routines and improve your sleep quality.

## Features

### Core MVP Features
- **Onboarding** (≤60s): Set bedtime/wake time, pick 3 micro-rituals, 4Q chronotype quiz
- **JIT Nudges**: T-30m before bedtime + "past-bedtime unlock" local notifications
- **Wind-down Mode**: Android DND toggle; iOS Shortcut template guide
- **Morning Check-in**: Track if you were in bed on time, energy level (1-5), mood (1-5), 7-day streak
- **Buddy Check**: One contact → prefilled SMS/WhatsApp if not in wind-down +20m
- **Data Privacy**: Local-only storage; JSON export; delete all data

### Design Principles
- **Night-first Visual Ergonomics**: Warm/neutral accents, reduced blue light
- **Minimal Cognitive Load**: One primary CTA per screen, progressive disclosure
- **Compassionate Tone**: No shame, supportive microcopy
- **Single-thumb Reach**: Primary actions bottom-aligned
- **Empty States Teach**: Every empty state has benefit + action

## Tech Stack

- **Flutter**: 3.24+
- **Dart**: 3.5+
- **State Management**: Riverpod (hooks)
- **Navigation**: GoRouter
- **Local Database**: Isar
- **Notifications**: flutter_local_notifications
- **Audio**: just_audio
- **Architecture**: Feature-first with /data, /domain, /ui subfolders

## Project Structure

```
lib/
├── core/
│   ├── database/          # Database service and configuration
│   ├── notifications/     # Notification service
│   ├── router/           # App routing configuration
│   ├── theme/            # Design system and theming
│   └── ui/               # Reusable UI components
├── features/
│   ├── home/             # Home screen and countdown
│   ├── onboarding/       # User setup flow
│   ├── wind_down/        # Wind-down rituals and DND
│   ├── morning_checkin/  # Daily check-in flow
│   ├── settings/         # App settings and preferences
│   └── notifications/    # Nudge system and events
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites
- Flutter 3.24+ installed
- Dart 3.5+
- Android Studio / Xcode for mobile development
- VS Code with Flutter extensions (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sleep_well_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## Configuration

### Environment Setup
The app uses local storage only - no external configuration needed.

### Permissions
- **Android**: Notifications, DND, exact alarms
- **iOS**: Notifications, background processing

### Database
Uses Isar for local storage with automatic encryption support.

## Features Overview

### Onboarding Flow
1. **Schedule Setup**: Set bedtime and wake time with quick presets
2. **Chronotype Quiz**: 4-question quiz to determine sleep type
3. **Ritual Selection**: Choose 3 wind-down rituals from curated options

### Wind-down Mode
- **Ritual Cards**: 60-second guided rituals with progress tracking
- **DND Toggle**: Android native DND, iOS Shortcut guide
- **Lo-fi Audio**: Gentle background sounds with fade in/out
- **Screen Dimming**: Optional overlay for reduced blue light

### Morning Check-in
- **Sleep Quality**: Were you in bed on time? (Y/N)
- **Energy Level**: 1-5 scale rating
- **Mood Tracking**: 1-5 scale rating
- **Streak Counter**: 7-day streak visualization

### Privacy & Data
- **Local Storage**: All data stays on device
- **Export**: JSON export of all user data
- **Delete**: Complete data deletion option
- **No Analytics**: Zero external data collection

## Design System

### Colors (Dark Theme)
- Background: `#0E1116`
- Surface: `#12161F`
- Text Primary: `#E6E9EE`
- Accent (Warm Teal): `#5ED0B5`
- Success: `#86EFAC`
- Warning: `#FBBF24`

### Typography
- Font Family: Montserrat
- H1: 28/34, H2: 22/28, Title: 18/24, Body: 16/22, Caption: 13/18
- Text scaling: 0.9-1.3x with layout stability

### Spacing
- Scale: 4, 8, 12, 16, 20, 24, 32dp
- Grid: 8dp base unit
- Card radius: 16-20dp

## Accessibility

- **AA Contrast**: ≥4.5:1 for all text
- **Hit Targets**: ≥44dp minimum
- **Semantic Labels**: Full TalkBack/VoiceOver support
- **Focus Order**: Predictable navigation
- **Color Blind Safe**: Never encode meaning with color alone

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Golden Tests
```bash
flutter test --update-goldens
```

## Performance

- **Cold Start**: <1.0s target
- **Frame Rate**: 60fps goal
- **Memory**: Safe disposal, no leaks
- **Battery**: No wake locks, scheduled notifications

## Privacy Summary

Sleep Well is designed with privacy as a core principle:

- ✅ **Local-only storage** - No cloud servers
- ✅ **No analytics** - Zero data collection
- ✅ **No tracking** - No third-party services
- ✅ **User control** - Export/delete anytime
- ✅ **Transparent** - Open source code

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Check the troubleshooting section in settings
- Review the privacy policy

---

**Sleep Well** - Building better sleep habits, one night at a time. 🌙
