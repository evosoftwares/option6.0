# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
- `flutter run` - Run the app on a connected device or emulator
- `flutter run -d chrome` - Run the app in Chrome browser
- `flutter run --debug` - Run in debug mode
- `flutter run --release` - Run in release mode for performance testing

### Build & Test
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web version
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

## Application Overview

This is a comprehensive **ride-sharing/transportation app** built with FlutterFlow that serves both **drivers** ("motoristas") and **passengers** ("passageiros") in Portuguese-speaking markets. The app supports complete trip lifecycle management, from booking to payment and ratings.

## Core Architecture

### Optimized Hybrid Architecture (UPDATED)
- **Firebase**: Authentication (`user_id`) + FCM Push Notifications only
- **Supabase**: Primary backend for ALL business logic, data storage, real-time features, and complex operations
- **Intelligent Systems**: AI-powered matching, smart notifications, and real-time analytics built on Supabase
- **Streamlined Integration**: Firebase provides essential services while Supabase handles all business complexity

### User Types & Authentication Flow
1. **Registration Process**: `lib/auth_option/`
   - Login → Registration → **Selfie Verification (REQUIRED FIRST)** → Profile Selection → Success
   - **CRITICAL**: After successful registration, users MUST be redirected to selfie verification (`context.pushNamedAuth('selfie', context.mounted)`)
   - Users then choose between "Sou Motorista" (I'm a Driver) or "Sou Passageiro" (I'm a Passenger)
   - Creates entries in both `AppUsersTable` (Supabase) and `DriversTable`/`PassengersTable`
   - Uses FCM token as user identifier (unusual but intentional design)

2. **User Types**:
   - **Driver**: Access to driver dashboard, trip acceptance, vehicle management, exclusion zones, earnings
   - **Passenger**: Access to trip booking, driver selection, preferences, trip history

### Navigation & Routing
- **GoRouter-based**: Declarative routing with authentication guards
- **Default Route**: Logged-in users default to driver dashboard (`MainMotoristaWidget`)
- **Dynamic User Type Detection**: Checks user type on load and redirects appropriately
- **Route Structure**: Clear separation between driver (`main_motorista_option/`) and passenger (`mai_passageiro_option/`) flows

## Feature Documentation

### Passenger Features (`mai_passageiro_option/`)
1. **Main Dashboard** (`main_passageiro/`): "Para onde vamos" - Trip booking interface
2. **Search Screen** (`search_screen/`): Location search with origin/destination/stops support
3. **Driver Selection** (`escolha_motorista/`): Choose from available drivers
4. **Waiting Screen** (`esperando_motorista/`): Real-time tracking while waiting for driver
5. **Preferences** (`preferencias/`): User settings and preferences management

### Driver Features (`main_motorista_option/`)
1. **Main Dashboard** (`main_motorista/`): Driver home screen with trip acceptance, timer, static map integration
2. **En Route Screen** (`a_caminho_do_passageiro/`): Navigation and passenger communication
3. **Vehicle Management** (`meu_veiculo/`): Vehicle details, registration, and document management
4. **Documents** (`documentos_motorista/`): Driver license, vehicle documents, photo uploads
5. **Trip History** (`minhas_viagens/`): Past trips and earnings
6. **Driver Menu** (`menu_motorista/`): Settings and profile management
7. **Exclusion Zones** (`zonasde_exclusao_motorista/`): Manage areas where driver won't accept trips
8. **Add Exclusion Zone** (`add_zona_exclusao/`): Create new exclusion zones

## Database Architecture (Supabase)

### Core Tables
- **`app_users`**: User profiles with `user_type` ('driver'/'passenger'), contact info, FCM tokens, device info
- **`drivers`**: Driver-specific data (vehicle info, approval status, online status, ratings)
- **`passengers`**: Passenger metrics (trip count, ratings, cancellations, payment methods)
- **`trips`**: Complete trip records (origin/destination, status, pricing, participants)
- **`trip_requests`**: Trip booking requests before driver assignment
- **`trip_stops`**: Multi-stop trip support
- **`ratings`**: Bidirectional rating system (driver rates passenger, passenger rates driver)

### Financial System
- **`wallet_transactions`**: Driver earnings and transaction history
- **`passenger_wallet_transactions`**: Passenger payment history
- **`passenger_wallets`**: Passenger wallet balances
- **`payment_methods`**: Stored payment method information
- **`withdrawals`**: Driver withdrawal requests and processing

### Operational Management
- **`driver_status`**: Real-time driver availability and online intent
- **`location_updates`**: Real-time location tracking during trips
- **`trip_location_history`**: Historical location data for completed trips
- **`trip_status_history`**: Audit trail of trip status changes
- **`operational_cities`**: Supported service areas
- **`driver_operational_cities`**: Cities where each driver operates

### Documentation & Compliance
- **`driver_documents`**: Driver license, vehicle registration, insurance docs
- **`driver_current_documents`**: Active document versions
- **`driver_approval_audit`**: Driver approval process tracking
- **`security_logs`**: Security event logging
- **`security_alerts`**: Automated security monitoring
- **`notifications`**: In-app notification system

### Additional Features
- **`saved_places`**: User-saved locations (home, work, etc.)
- **`available_drivers_view`**: Optimized view for finding nearby drivers

## Business Logic & Custom Code

### Intelligent Trip System (NEW) - 100% Supabase
- **`solicitar_viagem_inteligente.dart`**: AI-powered trip request system with smart driver matching
- **`aceitar_viagem_supabase.dart`**: Complete Supabase-based trip acceptance replacing Firebase
- **`conectar_interface_passageiro.dart`**: Dynamic passenger interface connected to real data
- **`sistema_notificacoes_tempo_real.dart`**: Real-time notification system with Supabase Realtime
- **`dashboard_inteligencia_viagens.dart`**: AI-powered analytics and system monitoring

### Legacy Custom Actions (`lib/custom_code/actions/`)
- **`aceitar_corrida.dart`**: ⚠️ DEPRECATED - Firebase-based trip acceptance (replaced)
- **`encontrar_motoristas_disponiveis_dinheiro.dart`**: Driver matching algorithm for cash payments
- **`buscar_prestadores.dart`**: Service provider search functionality
- **`criar_missoes_prestadores.dart`**: Create missions/tasks for service providers
- **Location & Real-time Tracking**: `encerrar_loc_em_tempo_real.dart`

### Rating & Evaluation System
- **`processar_avaliacao.dart`**: Complete rating processing with Supabase integration
- **`notificar_avaliacao_pendente.dart`**: Smart post-trip evaluation notifications
- **`integrar_avaliacao_viagem.dart`**: Trip completion with automatic rating triggers
- **`flutter_flow/rating_functions.dart`**: Helper functions for rating integration
- **Components**: `rating_estrelas_widget.dart`, `tags_avaliacao_widget.dart`

### Custom Functions (`lib/flutter_flow/custom_functions.dart`)
- **Geographic Utilities**: `converteLatLngSeparado()` - Parse LatLng strings
- **Geocoding**: `getCityFromGeocodingResponse()` - Extract city from geocoding API responses
- **Business Logic**: Trip calculation, distance measurement, pricing algorithms

### Action Blocks (`lib/actions/actions.dart`)
- **UI Feedback**: `alertaNegativo()`, `snackSalvo()` - User notification system
- **Data Sync**: `updateUserSupabase()` - Supabase data synchronization

## UI/UX Design System

### Theme Architecture (`lib/flutter_flow/flutter_flow_theme.dart`)
- **Material Design 2**: Custom theme extending Material Design
- **Typography**: Google Fonts integration (Roboto, Inter) with custom text styles
- **Color System**: Primary/secondary colors, accent colors, semantic colors (success, warning, error)
- **Component Library**: `FFButtonOptions`, custom widgets, icon buttons

### Component Structure (`lib/components/`)
- **Reusable Widgets**: `adfs_widget.dart`, `carro_widget.dart`, `jkbn_widget.dart`
- **FlutterFlow Components**: Generated UI components with custom styling
- **Custom Maps**: Google Maps integration with custom markers and styling

## Technical Integration

### Firebase Services
- **Authentication**: Email/password, phone auth, social login support
- **Cloud Functions**: FCM token management, push notifications, trip notifications
- **Cloud Firestore**: Real-time user sessions and authentication state
- **Firebase Storage**: Document and image uploads (driver documents, profile photos)
- **Firebase Messaging**: Push notifications for trip updates, driver matching

### Supabase Configuration
- **Database**: Primary data storage for all business logic
- **Real-time Subscriptions**: Trip status updates, driver location updates, notifications
- **Storage**: Additional file storage capabilities
- **Row Level Security**: Database security for multi-tenant data isolation
- **RPC Functions**: Custom PostgreSQL functions for intelligent matching and analytics

## Intelligent Trip System (NEW)

### AI-Powered Driver Matching
- **Multi-Factor Scoring Algorithm**: Combines proximity (35%), rating (25%), acceptance rate (20%), location freshness (10%), and cancellation history (10%)
- **Progressive Search**: Starts with 3km radius, expands to 6km, 9km, up to 15km maximum
- **Smart Fallback System**: Intelligent queue with up to 4 backup drivers per request
- **Real-time Optimization**: Considers driver behavior patterns and historical acceptance rates

### Smart Trip Request Flow
1. **Intelligent Request Creation**: `solicitar_viagem_inteligente.dart`
   - Creates trip request with estimated pricing and duration
   - Executes multi-factor driver matching algorithm
   - Sets up automatic fallback chain with timeout management
   - Sends targeted notifications to optimal drivers

2. **Advanced Driver Selection**:
   - RPC function `buscar_motoristas_inteligentes` queries optimized drivers
   - Filters by vehicle category, special needs (pet, AC, grocery space, condo access)
   - Applies real-time scoring based on multiple performance metrics
   - Returns ranked list sorted by compatibility score

3. **Automatic Timeout & Fallback**:
   - 30-second response window per driver
   - Automatic progression through fallback queue
   - Smart re-routing when drivers become unavailable
   - Graceful degradation with "no drivers available" handling

### Real-Time Notification System
- **Supabase Realtime**: Instant notifications via database subscriptions
- **Targeted Messaging**: Driver-specific trip offers with estimated earnings
- **Passenger Updates**: Real-time driver assignment and arrival notifications
- **Automatic Cleanup**: Cancels pending notifications when trip is accepted
- **Persistent History**: All notifications stored for analytics and user reference

### Dynamic Passenger Interface
- **Live Driver Availability**: Real-time count and ETA based on current location
- **Historical Trip Integration**: Shows past trips from Supabase with full details
- **Active Trip Monitoring**: Tracks ongoing trips with driver information
- **Smart Pricing**: Dynamic fare calculation based on distance, stops, and demand
- **Preference-Based Filtering**: Matches passenger needs with driver capabilities

### Analytics & Performance Monitoring
- **Real-Time System Health**: Monitors active drivers, pending requests, error rates
- **Performance Metrics**: Tracks acceptance rates, response times, completion rates
- **Business Intelligence**: Identifies peak hours, popular routes, revenue patterns
- **Operational Insights**: Automated recommendations for driver allocation and pricing
- **Health Scoring**: 0-100 system health score with automated alerts

### Third-Party Integrations
- **Google Maps**: Trip visualization, route planning, location services
- **Mapbox Search**: Enhanced location search and geocoding
- **Geolocator**: Real-time location tracking
- **Payment Processing**: Support for payment method storage and processing

## Development Patterns

### State Management
- **Provider Pattern**: App-wide state with `FFAppState` extending `ChangeNotifier`
- **Secure Storage**: Sensitive data (API keys, tokens) stored in `FlutterSecureStorage`
- **Model Architecture**: Each screen has a dedicated model class extending `FlutterFlowModel`

### Data Flow
1. **Authentication**: Firebase Auth → User creation in Supabase
2. **User Type**: Profile selection → Database role assignment → Route redirection
3. **Trip Flow**: Request → Driver matching → Real-time tracking → Payment → Rating
4. **Real-time Updates**: Supabase real-time subscriptions + Firebase messaging

### Error Handling & Security
- **Secure Token Management**: JWT tokens, API keys in secure storage
- **Input Validation**: Form validation, data sanitization with robust email/password validation
- **Audit Trails**: Security logs, approval processes, status change tracking
- **Geographic Restrictions**: Operational cities, driver exclusion zones
- **Critical Android Configuration**: AndroidManifest.xml must have clean permissions (no empty `<uses-permission android:name="android.permission."/>` entries)

## Key Implementation Notes

1. **FlutterFlow Generated**: Many components are auto-generated; custom code is in `lib/custom_code/`
2. **Portuguese Localization**: App text in Portuguese with "Indica AI" branding
3. **Multi-Platform**: Optimized for Android, iOS, and Web with platform-specific features
4. **Real-time Architecture**: Combines Firebase real-time capabilities with Supabase's powerful querying
5. **Scalable Design**: Supports multiple cities, driver approval workflows, financial processing
6. **Security-First**: Comprehensive logging, document verification, user verification (selfie)

This is a production-ready ride-sharing platform with enterprise-level features including document management, financial processing, real-time tracking, and comprehensive user management.

## Implementation Guide for Intelligent System

### Required Supabase Setup
1. **Execute RPC Functions**: Run `supabase_functions.sql` to create intelligent matching functions
2. **Enable Realtime**: Configure Supabase Realtime for notifications table
3. **Database Triggers**: Automatic rating calculations and statistics updates are handled by triggers
4. **Performance Indices**: Optimized database indices for location-based queries

### Integration Steps
1. **Replace Legacy Trip Logic**:
   - Use `solicitar_viagem_inteligente.dart` instead of old Firebase-based requests
   - Implement `aceitar_viagem_supabase.dart` for driver acceptance flow
   - Connect passenger interface with `conectar_interface_passageiro.dart`

2. **Enable Real-Time Notifications**:
   - Initialize `SistemaNotificacoesTempoReal` in app startup
   - Wrap main screens with `NotificationListener` widget
   - Configure FCM integration for urgent notifications

3. **Dashboard Integration**:
   - Use `dashboard_inteligencia_viagens.dart` for admin/analytics screens
   - Monitor system health with real-time metrics
   - Set up automated alerts based on health scores

### Firebase Configuration (Required)
- **Authentication**: Continue using Firebase Auth for `user_id` generation
- **FCM Setup**: Configure Firebase Cloud Messaging for push notifications
- **Token Management**: Store FCM tokens in Supabase `user_devices` table
- **Notification Integration**: Use Firebase for delivery, Supabase for logic and storage

### Performance Optimizations
- **Database Indices**: Location-based queries optimized with spatial indices
- **Connection Pooling**: Supabase handles database connections efficiently
- **Caching Strategy**: Real-time data balanced with cached historical data
- **Progressive Loading**: Large datasets loaded incrementally

### Monitoring & Maintenance
- **Health Monitoring**: Automated system health checks every 5 minutes
- **Performance Analytics**: Track matching efficiency and response times
- **Data Cleanup**: Automated cleanup of old location data and notifications
- **Scaling Preparation**: System designed to handle increased driver/passenger volume

### Next Phase Recommendations
1. **Machine Learning Enhancement**: Implement ML-based demand prediction
2. **Advanced Pricing**: Dynamic surge pricing based on real-time demand
3. **Route Optimization**: AI-powered route suggestions for drivers
4. **Predictive Analytics**: Forecast driver availability and passenger demand
5. **A/B Testing Framework**: Test different matching algorithms and pricing strategies

This intelligent system provides a solid foundation for scaling operations while maintaining optimal user experience and operational efficiency.

## Critical Development Guidelines

### Authentication Flow Requirements
- **MANDATORY**: Registration must redirect to selfie verification screen immediately after successful Firebase/Supabase user creation
- **Validation**: All form inputs must have robust validation (email regex, minimum 6-character passwords)
- **Error Handling**: Firebase authentication errors must be handled with specific Portuguese error messages

### Android Configuration Requirements
- **AndroidManifest.xml**: Must have clean, valid permission declarations - no empty permission entries
- **Google Services**: Ensure `google-services.json` matches the exact package name in `build.gradle` (`com.evo.opt2`)
- **Firebase**: Requires proper initialization in `main.dart` with both Firebase and Supabase setup

### Common Issues & Solutions
1. **Firebase Auth Failures**: Usually caused by malformed AndroidManifest.xml permissions
2. **Compilation Errors**: Remove any direct Firebase imports in widgets - use `authManager` instead
3. **Registration Flow**: Must follow exact sequence: Form → Firebase Auth → Supabase Insert → Selfie Redirect

### Code Quality Standards
- **Error Messages**: All user-facing messages in Portuguese
- **Loading States**: Implement proper loading indicators during async operations
- **Form Validation**: Client-side validation with specific error messages for each field type