# GlobalTrustHub Frontend

[![Flutter CI](https://github.com/asifgondal786/globaltrusthubfrontend/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/asifgondal786/globaltrusthubfrontend/actions/workflows/flutter_ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

A modern, cross-platform mobile and web application for **GlobalTrustHub** - a trusted digital ecosystem connecting students, job seekers, universities, and employers worldwide.

## 🚀 Features

-   **Multi-Role Authentication**: Secure login for Students, Job Seekers, Agents, and Employers.
-   **Dynamic Dashboard**: Personalized home screen with widgets for Top Rated services, News, and Quick Actions.
-   **Dark Mode Support**: Fully responsive UI that adapts to system theme preferences.
-   **Service Marketplace**: Browse universities, visa consultants, and job listings.
-   **Journey Tracking**: Visual progress tracker for your study or work abroad journey.
-   **Secure Verification**: Integration with backend for trust scoring and fraud prevention.

## 🛠️ Tech Stack

-   **Framework**: [Flutter](https://flutter.dev) (Web, Android, iOS)
-   **Language**: Dart
-   **State Management**: Provider
-   **Routing**: GoRouter
-   **Networking**: Dio (with Interceptors for Auth)
-   **Hosting**: Firebase Hosting

## 🏁 Getting Started

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
-   [VS Code](https://code.visualstudio.com/) or Android Studio.
-   A running instance of [GlobalTrustHub Backend](https://github.com/asifgondal786/globaltrusthubbackend).

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/asifgondal786/globaltrusthubfrontend.git
    cd globaltrusthubfrontend
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App (Development)**:
    Ensure your local backend is running (default: `http://127.0.0.1:8080`).
    
    *Run on Chrome:*
    ```bash
    flutter run -d chrome
    ```

### Configuration

The app is pre-configured to connect to `localhost:8080` for development.
To change the API URL for production, update `lib/core/api/api_config.dart`.

## 📦 Deployment

This project is configured for **Firebase Hosting**.

1.  **Build not web**:
    ```bash
    flutter build web --release
    ```

2.  **Deploy**:
    ```bash
    firebase deploy
    ```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
