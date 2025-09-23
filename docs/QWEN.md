# QWEN.md - Project Context for Option

## Project Overview

This is a comprehensive **ride-sharing/transportation app** built with FlutterFlow that serves both **drivers** ("motoristas") and **passengers** ("passageiros") in Portuguese-speaking markets. The app supports complete trip lifecycle management, from booking to payment and ratings.

### Core Architecture
- **Hybrid Backend Architecture**:
  - **Firebase**: Authentication (`user_id`) + FCM Push Notifications only
  - **Supabase**: Primary backend for ALL business logic, data storage, real-time features, and complex operations
  - **Intelligent Systems**: AI-powered matching, smart notifications, and real-time analytics built on Supabase

### Key Technologies
- Flutter SDK (>=3.0.0 <4.0.0)
- Firebase Suite (Auth, Messaging, Storage)
- Supabase (Primary backend with `supabase_flutter: 2.9.0`)
- Google Maps & Geolocation services
- Provider for state management
- GoRouter for navigation
- Background services and local notifications

## Project Structure

```
lib/
├── actions/                 # Custom actions and utilities
├── auth/                    # Authentication flows
├── auth_option/             # Registration and authentication screens
├── avaliacao_option/        # Rating and evaluation system
├── backend/                 # Backend integrations (Supabase, Firebase)
├── components/              # Reusable UI components
├── custom_code/             # Custom business logic
│   ├── actions/             # Custom actions
│   └── widgets/             # Custom widgets
├── flutter_flow/            # FlutterFlow generated code
├── mai_passageiro_option/   # Passenger features
└── main_motorista_option/   # Driver features
```

## Development Commands

### Running the App
- `flutter run` - Run the app on a connected device or emulator
- `flutter run -d chrome` - Run the app in Chrome browser
- `flutter run --debug` - Run in debug mode
- `flutter run --release` - Run in release mode for performance testing

### Building & Deployment
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web version

### Testing
- `flutter test` - Run all tests
- `flutter test test/specific_test.dart` - Run a specific test file

### Code Quality
- `flutter analyze` - Run static analysis (lint checks)
- `dart format .` - Format all Dart code
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Install dependencies after pubspec.yaml changes

### Firebase Functions
- `cd firebase/functions && npm install` - Install Firebase Functions dependencies
- `firebase deploy --only functions` - Deploy cloud functions
- `firebase emulators:start` - Start local Firebase emulators

## Authentication Flow

1. **Registration Process**: 
   - Login → Registration → **Selfie Verification (REQUIRED FIRST)** → Profile Selection → Success
   - After successful registration, users MUST be redirected to selfie verification
   - Users then choose between "Sou Motorista" (I'm a Driver) or "Sou Passageiro" (I'm a Passenger)

2. **User Types**:
   - **Driver**: Access to driver dashboard, trip acceptance, vehicle management
   - **Passenger**: Access to trip booking, driver selection, preferences

## Key Features

### Passenger Features (`mai_passageiro_option/`)
1. Main Dashboard - Trip booking interface
2. Search Screen - Location search with origin/destination/stops support
3. Driver Selection - Choose from available drivers
4. Waiting Screen - Real-time tracking while waiting for driver
5. Preferences - User settings and preferences management

### Driver Features (`main_motorista_option/`)
1. Main Dashboard - Driver home screen with trip acceptance
2. En Route Screen - Navigation and passenger communication
3. Vehicle Management - Vehicle details and document management
4. Documents - Driver license and vehicle documents
5. Trip History - Past trips and earnings

## Database Architecture (Supabase)

Core tables include:
- `app_users` - User profiles
- `drivers` - Driver-specific data
- `passengers` - Passenger metrics
- `trips` - Complete trip records
- `trip_requests` - Trip booking requests
- `ratings` - Bidirectional rating system

Financial system tables:
- `wallet_transactions` - Driver earnings
- `passenger_wallets` - Passenger wallet balances
- `payment_methods` - Stored payment methods

## Environment Configuration

The project uses a `.env` file for configuration with:
- Supabase URLs and API keys
- Google Maps API key
- Firebase configuration
- Asaas payment API keys

## Development Guidelines

### Code Organization
- Custom business logic should be placed in `lib/custom_code/actions/` for actions and `lib/custom_code/widgets/` for custom widgets
- FlutterFlow generated code is in `lib/flutter_flow/` and is excluded from linting
- All user-facing messages should be in Portuguese

### Authentication Requirements
- Registration must redirect to selfie verification immediately after successful user creation
- All form inputs must have robust validation
- Firebase authentication errors must be handled with specific Portuguese error messages

### Android Configuration
- AndroidManifest.xml must have clean, valid permission declarations
- Ensure `google-services.json` matches the exact package name (`com.evo.opt2`)

## Intelligent Trip System

The app features an AI-powered trip request system with:
- Smart driver matching algorithm
- Real-time notification system
- Dynamic passenger interface
- Analytics and performance monitoring

This system replaces legacy Firebase-based trip logic with Supabase-powered intelligent matching.