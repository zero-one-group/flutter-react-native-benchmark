# Flutter vs React Native Performance Benchmark

A comprehensive performance benchmark comparing React Native and Flutter mobile app development frameworks. This repository contains the source code and test implementations used in the [Zero One Group performance benchmark study](https://blog.zero-one-group.com/performance-benchmark-react-native-vs-flutter-mobile-app-f879ee2ebf36).

## 📊 Benchmark Overview

This benchmark evaluates the performance of React Native (with New Architecture enabled) and Flutter across multiple metrics:

- **CPU Utilization** - Processing power required during rendering and interactions
- **Memory Usage** - Memory allocation and management efficiency
- **Frame Rate (FPS)** - Rendering smoothness during animations
- **App Startup Time** - Cold start performance from launch to first UI
- **App Size** - Binary size comparison across platforms

## 🏗️ Project Structure

This repository contains three separate applications implementing identical functionality:

```
flutter-react-native-benchmark/
├── flutter_app/                    # Flutter implementation
├── rn-plain-app/                   # React Native with Expo (New Architecture)
├── rn-tamagui-app/                 # React Native with Tamagui UI framework
└── README.md
```

### Flutter App (`flutter_app/`)

- **Framework**: Flutter 3.7+
- **Language**: Dart
- **Architecture**: Provider pattern with MVVM
- **Key Dependencies**: `provider`, `reorderable_grid_view`

### React Native Plain App (`rn-plain-app/`)

- **Framework**: React Native 0.76.7 with Expo SDK 52
- **Language**: TypeScript
- **Architecture**: New Architecture enabled (`newArchEnabled: true`)
- **Key Dependencies**: `react-native-reanimated`, `react-native-draggable-grid`

### React Native Tamagui App (`rn-tamagui-app/`)

- **Framework**: React Native 0.76.7 with Expo SDK 52
- **Language**: TypeScript
- **UI Framework**: Tamagui
- **Key Dependencies**: `tamagui`, `react-native-reanimated`

## 🧪 Benchmark Scenarios

### 1. Pure UI Performance

- **Task**: Render a 10,000-item list with lazy loading
- **Features**: Smooth scrolling, basic animations, color transitions
- **Metrics**: CPU, Memory, Frame Rate

### 2. Resource-Intensive Tasks

- **Task**: Complex animations with 100-tile grid
- **Features**: Color border animations, shadows, drag-and-drop, background rotations
- **Metrics**: CPU, Memory, Frame Rate

### 3. Input Responsiveness

- **Task**: High-load interactions during animations
- **Features**: Rapid drag-and-drop, button taps during background animations
- **Metrics**: Frame Rate, CPU, Memory

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn
- Flutter SDK 3.7+
- Expo CLI (`npm install -g @expo/cli`)
- Android Studio / Xcode for device testing

### Running the Applications

#### Flutter App

```bash
cd flutter_app
flutter pub get
flutter run
```

#### React Native Plain App

```bash
cd rn-plain-app
npm install
npx expo start
```

#### React Native Tamagui App

```bash
cd rn-tamagui-app
npm install
npx expo start
```

## 📱 Testing

### Manual Testing

Each app includes three main test screens accessible from the home screen:

1. **UI Performance** - List rendering test
2. **Intensive Tasks** - Complex animation test
3. **Input Responsiveness** - Interaction responsiveness test

### Automated Testing

#### Flutter Integration Tests

```bash
cd flutter_app
flutter test integration_test/
```

#### React Native Maestro Tests

```bash
# Install Maestro
curl -Ls "https://get.maestro.mobile.dev" | bash

# Run tests
cd rn-plain-app
maestro test maestro/performance-test.yml
maestro test maestro/intensive-task.yml
maestro test maestro/input-responsiveness.yml
```

## 📊 Benchmark Results

Based on the comprehensive study, key findings include:

### Performance Comparison

- **CPU Usage**: Flutter shows more efficient CPU utilization, especially during resource-intensive operations
- **Memory Usage**: Flutter demonstrates better memory management across all scenarios
- **Frame Rate**: Flutter maintains more stable frame rates with fewer drops

### Platform-Specific Results

- **Android**: Flutter APK is significantly smaller, faster cold-start times
- **iOS**: React Native has slight advantages in IPA size and cold-start performance

### Architecture Impact

React Native's New Architecture (Fabric, JSI, TurboModules) shows improvements but still lags behind Flutter in resource-intensive scenarios.

## 🔧 Development Notes

### React Native New Architecture

The React Native apps have the New Architecture enabled:

```json
{
  "expo": {
    "newArchEnabled": true
  }
}
```

### Performance Profiling

For accurate benchmarking, use:

- **Android**: Android Studio Profiler
- **iOS**: Xcode Instruments
- **Release Mode**: All tests should be conducted in release builds

## 📚 Additional Resources

- [Full Benchmark Report](https://blog.zero-one-group.com/performance-benchmark-react-native-vs-flutter-mobile-app-f879ee2ebf36)
- [Flutter Documentation](https://docs.flutter.dev/)
- [React Native Documentation](https://reactnative.dev/)
- [Expo Documentation](https://docs.expo.dev/)

## 🤝 Contributing

This repository is part of an ongoing performance study. For questions or contributions, please contact the research team at [Zero One Group](https://www.zero-one-group.com).

## 📄 License

This project is for research and educational purposes. Please refer to individual app licenses for specific usage terms.

---

**Research Team**: Muhammad Rijalul Kahfi, Dharma Yudistira Eka Putra, Dyva Pandhu, Muhammad Widodo, Johan Sutrisno  
**Organization**: [Zero One Group](https://www.zero-one-group.com)
