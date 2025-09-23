# Project Overview

This is a Flutter project named "option" that appears to be a ride-hailing service. The application allows users to request rides, and drivers to accept them. It uses a combination of Firebase and Supabase for its backend services.

**Key Technologies:**

*   **Frontend:** Flutter
*   **Backend:** Firebase (Authentication, Push Notifications), Supabase (Database, Cloud Functions)
*   **Mapping:** Google Maps
*   **State Management:** Provider
*   **Navigation:** GoRouter
*   **Testing:** flutter_test, mockito

**Architecture:**

The project follows a standard Flutter project structure.
*   `lib/` contains the main application code.
*   `lib/main.dart` is the entry point of the application, initializing Firebase and Supabase.
*   `lib/backend/` contains the backend service integrations.
*   `lib/auth/` handles user authentication.
*   `lib/custom_code/` contains custom actions and widgets.
*   `test/` contains the project's tests.

# Building and Running

**To build and run the project:**

```bash
flutter pub get
flutter run
```

**To run the tests:**

```bash
flutter test
```

# Development Conventions

*   **Testing:** The project uses the `mockito` package for mocking dependencies in tests. Tests are located in the `test/` directory and follow a feature-based organization. The tests cover business logic, API integrations, and UI components.
*   **State Management:** The project uses the `provider` package for state management.
*   **Backend:** The project uses both Firebase and Supabase for backend services. Firebase is used for authentication and push notifications, while Supabase is used for the database and cloud functions.
*   **Environment Variables:** The project uses a `.env` file for managing environment variables.
