# Autism-Empowering

A comprehensive Flutter application designed to empower individuals and families affected by autism. The app provides interactive games, diagnostic tools, chat with doctors, routine management, and more, all in a supportive and accessible environment.

## Features

- **Authentication**: Secure login and registration for parents and doctors.
- **Child Information Management**: Add, update, and view detailed child profiles.
- **Diagnosis Tools**: Includes questionnaire-based and image/fMRI-based diagnostic modules.
- **Interactive Games**: Educational games such as drag-and-drop, puzzle, and clock games to support cognitive development.
- **Routine Management**: Create and manage daily routines for children.
- **Doctor Interaction**: Find doctors, send follow requests, and chat securely.
- **Chat System**: Real-time chat between parents and doctors.
- **Notifications**: In-app and push notifications for important updates.
- **Localization**: Multi-language support (see `l10n.yaml`).
- **Rich Media**: Animations, images, and sound to enhance user engagement.

## Directory Structure

- `lib/Controller/` – Business logic and controllers (Auth, Chat, Notification, etc.)
- `lib/Model/` – Data models (User, Doctor, Child Info, Routine, Game Data, etc.)
- `lib/View/` – UI screens and widgets (Auth, Chat, Games, Diagnosis, Routine, etc.)
- `assets/` – Images, animations, fonts, models, and other static resources

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (see `pubspec.yaml` for version)
- Firebase account (for authentication, Firestore, messaging, etc.)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd Autism-Empowering
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective directories.
   - Update Firebase project settings as needed.
4. **Run the app:**
   ```bash
   flutter run
   ```

## Assets
- **Images:** Educational and game-related images in `assets/images/`, `assets/animals/`, `assets/fruits/`
- **Animations:** Lottie and Rive animations in `assets/animations/`, `assets/rive/`
- **Models:** TensorFlow Lite model for face analysis in `assets/models/`
- **Fonts:** Custom fonts in `assets/fonts/`

## Main Dependencies
- `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `firebase_storage` – Firebase integration
- `get`, `bloc`, `flutter_bloc`, `flutter_riverpod` – State management
- `awesome_notifications`, `onesignal_flutter` – Notifications
- `lottie`, `rive` – Animations
- `tflite` – Machine learning model integration
- `image_picker`, `file_picker` – Media and file handling
- `shared_preferences` – Local storage

## Contributing
Contributions are welcome! Please open issues and submit pull requests for improvements or bug fixes.

## License
Specify your license here (e.g., MIT, Apache 2.0, etc.)

## Screenshots
Add screenshots or GIFs here to showcase the app.

---

*Empowering families and individuals with autism through technology.*
