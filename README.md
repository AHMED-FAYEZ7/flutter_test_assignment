# flutter_test_assignment

* #This is a Flutter application demonstrating the use of Firebase Auth for user authentication, Firestore for cloud storage, Drift for offline caching, and Riverpod for state management.
* #The app allows users to register, log in, manage tasks, and sync data between Firestore and the local database.
* #It follows the MVVM architecture and Clean Architecture principles.

## Used Packages

* firebase_core: Initializes Firebase for your Flutter app.
* firebase_auth: Handles user authentication with Firebase (email/password).
* cloud_firestore: Provides Firestore integration for cloud-based data storage.
* flutter_riverpod: State management solution for Flutter, enabling a clean and testable architecture.
* riverpod_annotation: Generates code for Riverpod providers.
* drift: A local SQLite database for offline data caching.
* go_router: Simplifies navigation and routing in Flutter.
* mockito: A package for mocking objects in tests.
* path_provider: Provides paths to directories on the device for storing files.
* flutter_phoenix: Used for restarting the app (e.g., after logging out).

## Notes
* Offline Access: Tasks are cached locally using Drift, and sync with Firestore is automatic.
* User Authentication: Users must log in to manage tasks. Tasks are associated with the logged-in user.
* Data Sync: Firestore is the source of truth, and changes are reflected both remotely and locally.
