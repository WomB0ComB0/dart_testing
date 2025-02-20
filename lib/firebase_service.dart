import 'dart:io';
import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

import 'environment.dart';
import 'firebase_exception_code.dart';

/// A service class that manages Firebase Admin SDK initialization and provides access to Firebase services.
///
/// This class handles the initialization of Firebase Admin SDK and provides
/// access to commonly used Firebase services like Authentication and Firestore.
/// It follows a singleton pattern to ensure only one instance is initialized.
///
/// Example usage:
/// ```dart
/// final firebaseService = FirebaseService();
/// await firebaseService.init();
/// final auth = firebaseService.auth;
/// ```
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  FirebaseAdminApp? _admin;
  Auth? _auth;
  Firestore? _firestore;

  bool _initialized = false;

  /// Whether Firebase Admin SDK has been initialized.
  bool get isInitialized => _initialized;

  /// The Firebase Admin SDK app instance.
  ///
  /// Throws a [StateError] if accessed before initialization.
  FirebaseAdminApp get adminApp {
    _checkInitialization();
    return _admin!;
  }

  /// The Firebase Authentication instance.
  ///
  /// Use this to access authentication related functionality.
  /// Throws a [StateError] if accessed before initialization.
  Auth get auth {
    _checkInitialization();
    return _auth!;
  }

  /// The Firestore instance.
  ///
  /// Use this to access Firestore database operations.
  /// Throws a [StateError] if accessed before initialization.
  Firestore get firestore {
    _checkInitialization();
    return _firestore!;
  }

  /// Initializes Firebase Admin SDK and its core services.
  ///
  /// This method must be called before using any Firebase functionality.
  /// It initializes:
  /// - Firebase Admin SDK
  /// - Firebase Authentication
  /// - Firestore
  ///
  /// If Firebase is already initialized, this method does nothing.
  ///
  /// Throws:
  ///   - [FirebaseException] if initialization fails
  Future<void> init() async {
    if (!_initialized) {
      try {
        _admin = FirebaseAdminApp.initializeApp(
          Env.projectId,
          File('service-account.json').existsSync()
              ? Credential.fromServiceAccount(File('service-account.json'))
              : Credential.fromServiceAccountParams(
                  clientId: Env.clientId,
                  privateKey: Env.privateKey,
                  email: Env.clientEmail,
                ),
        );

        _auth = Auth(_admin!);
        _firestore = Firestore(_admin!);

        _initialized = true;
      } catch (e, stackTrace) {
        throw FirebaseException(
          'Failed to initialize Firebase Admin SDK: $e',
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// Closes the Firebase Admin SDK connection and cleans up resources.
  ///
  /// This should be called when shutting down your application.
  Future<void> close() async {
    if (_initialized) {
      await _admin?.close();
      _initialized = false;
    }
  }

  /// Checks if the service is initialized.
  ///
  /// Throws a [StateError] if the service hasn't been initialized.
  void _checkInitialization() {
    if (!_initialized) {
      throw StateError(
        'FirebaseService must be initialized before accessing its services. '
        'Call init() first.',
      );
    }
  }
}

/// Global instance of FirebaseService for convenience
final firebaseService = FirebaseService.instance;
