# ListyNest - Classified Ads Application

ListyNest is a feature-rich classified ads application built with Flutter. It provides a platform for users to browse, search, and post advertisements for various goods and services.

## Features

*   **User Authentication:** Secure user sign-up and login functionality.
*   **Home Screen:** Displays a list of recent ads for quick browsing.
*   **Advanced Search & Filtering:** A powerful search screen that allows users to filter ads by:
    *   Category
    *   Price Range
    *   Keywords
*   **Bottom Navigation:** Intuitive navigation to switch between Home, Search, and Menu screens.
*   **Settings Screen:** A dedicated screen for users to manage their profile, notifications, and other preferences.
*   **Custom App Bar:** A consistent and customizable app bar used throughout the application.
*   **Generic UI Widgets:** Reusable widgets for displaying loading, error, and empty states, ensuring a consistent user experience.
*   **Provider State Management:** Efficient state management using the `provider` package.
*   **REST API Integration:** Fetches and posts data to a backend server.

## Technologies Used

*   **Flutter:** For building the cross-platform mobile application.
*   **Dart:** The programming language for Flutter.
*   **Provider:** For state management.
*   **Flutter Secure Storage:** For securely storing user authentication tokens.

## Screens

*   **Login & Sign Up:** For user authentication.
*   **Auth Wrapper:** Directs users to the appropriate screen based on their authentication state.
*   **Main Screen:** The main container with the bottom navigation bar.
*   **Home Screen:** Displays recent ads.
*   **Search Screen:** Allows users to search and filter ads.
*   **Menu Screen:** Provides access to settings and other options.
*   **Settings Screen:** For managing app and user settings.

## How to Run

1.  Ensure you have a `lib/config/app_config.dart` file with your API base URL.
2.  Run `flutter pub get` to install dependencies.
3.  Run `flutter run` to launch the application.
