# Sleep Tracker App

A comprehensive Flutter-based sleep tracking and optimization app with a beautiful dark theme and modern UI.

## Features

### 🏠 Dashboard
- Sleep metrics and quality scores
- Sleep debt tracking
- Sleep stages visualization
- Smart insights and recommendations
- Quick actions for sleep tracking

### 🎯 Onboarding
- Sleep goal selection
- Bedtime setup
- Personalized experience configuration

### 📊 Analytics Hub
- Quick wins for better sleep
- Sleep consistency insights
- Personalized recommendations
- Full sleep data reports

### 🎵 Soundscapes
- Meditation tracks
- Nature sounds
- ASMR content
- Binaural beats
- Favorites and recently played

## Design System

### Colors
- **Primary Blue**: `#007AFF` - Main accent color
- **Dark Background**: `#0A0A0A` - App background
- **Card Background**: `#1C1C1E` - Card surfaces
- **Text Primary**: `#FFFFFF` - Main text
- **Text Secondary**: `#8E8E93` - Secondary text
- **Success Green**: `#34C759` - Success states
- **Warning Orange**: `#FF9500` - Warning states

### Typography
- **Font Family**: Inter (Google Fonts)
- **Headings**: Bold, 20-32px
- **Body Text**: Regular, 12-16px
- **Captions**: Regular, 11px

### Components
- **Custom Cards**: Rounded corners, subtle shadows
- **Primary Buttons**: Blue gradient, full-width
- **Secondary Buttons**: Outlined, customizable
- **Metric Cards**: Data display with icons
- **Quick Win Cards**: Actionable tips

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart          # Theme configuration
│   └── constants/
│       └── app_constants.dart      # App constants
├── features/
│   ├── dashboard/
│   │   └── dashboard_screen.dart   # Main dashboard
│   ├── onboarding/
│   │   └── onboarding_screen.dart  # Onboarding flow
│   ├── analytics/
│   │   └── analytics_screen.dart   # Analytics hub
│   └── soundscapes/
│       └── soundscapes_screen.dart # Audio library
├── shared/
│   ├── models/
│   │   └── sleep_data.dart         # Data models
│   └── widgets/
│       ├── custom_card.dart        # Card components
│       └── custom_button.dart      # Button components
└── main.dart                       # App entry point
```

## Getting Started

1. **Prerequisites**
   - Flutter SDK (3.5.0 or higher)
   - Dart SDK (3.5.0 or higher)
   - Android Studio / VS Code
   - iOS Simulator / Android Emulator

2. **Installation**
   ```bash
   # Clone the repository
   git clone <repository-url>
   cd sleep_tracker_app
   
   # Install dependencies
   flutter pub get
   
   # Run the app
   flutter run
   ```

3. **Development**
   ```bash
   # Run in debug mode
   flutter run --debug
   
   # Run in release mode
   flutter run --release
   
   # Run tests
   flutter test
   
   # Analyze code
   flutter analyze
   ```

## Dependencies

- **State Management**: `flutter_riverpod`, `hooks_riverpod`, `flutter_hooks`
- **Navigation**: `go_router`
- **UI**: `google_fonts`, `flutter_svg`
- **Data**: `shared_preferences`, `hive`, `hive_flutter`
- **Audio**: `just_audio`, `audio_service`
- **Notifications**: `flutter_local_notifications`, `permission_handler`
- **Charts**: `fl_chart`
- **Utils**: `intl`, `path_provider`, `url_launcher`

## Screenshots

The app features a modern dark theme with:
- Clean, minimal interface
- Intuitive navigation
- Beautiful data visualizations
- Smooth animations and transitions
- Accessible design patterns

## Future Enhancements

- [ ] Sleep tracking with device sensors
- [ ] Smart alarm functionality
- [ ] Sleep coaching and tips
- [ ] Data export and sharing
- [ ] Offline mode support
- [ ] Wearable device integration
- [ ] Advanced analytics and insights
- [ ] Social features and challenges

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.