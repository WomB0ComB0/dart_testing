/// {@template firebase}
/// Firebase Admin SDK configuration and service instances.
/// {@endtemplate}
library;

import 'dart:io';
import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

import 'environment.dart';
import 'firebase_exception_code.dart';

/// Firebase Admin SDK configuration and service instances.
///
/// This file provides centralized access to Firebase Admin SDK services and handles
/// initialization of the Admin SDK. It exposes commonly used Firebase services like
/// Authentication and Firestore through singleton instances.
///
/// The initialization process:
/// 1. Attempts to load credentials from a local service account file
/// 2. Falls back to environment variables if file not found
/// 3. Initializes the Admin SDK with the credentials
///
/// Usage:
/// ```dart
/// // Access Firestore
/// final users = await firestore.collection('users').get();
///
/// // Access Authentication
/// final user = await auth.getUserByEmail('user@example.com');
///
/// // Cleanup on shutdown
/// await admin.close();
/// ```
///
/// Important: Always call `admin.close()` when shutting down your application
/// to properly cleanup resources.

/// The Firebase Admin SDK app instance.
///
/// This is the main entry point for Firebase Admin SDK functionality.
/// It's initialized with project credentials using one of two methods:
///
/// 1. From a local service account JSON file ('service-account.json')
/// 2. From environment variables (clientId, privateKey, clientEmail)
///
/// The initialization is performed immediately when the app starts using
/// an IIFE (Immediately Invoked Function Expression).
///
/// Throws:
///   - [FirebaseException] if initialization fails, with detailed error message
///     and stack trace
///
/// Example:
/// ```dart
/// // Access the admin instance
/// final app = admin;
///
/// // Close the admin app
/// await admin.close();
/// ```
final FirebaseAdminApp admin = (() {
  try {
    return FirebaseAdminApp.initializeApp(
      Env.projectId,
      File('service-account.json').existsSync()
          ? Credential.fromServiceAccount(File('service-account.json'))
          : Credential.fromServiceAccountParams(
              clientId: Env.clientId,
              privateKey: Env.privateKey,
              email: Env.clientEmail,
            ),
    );
  } catch (e) {
    throw FirebaseException(
      'Failed to initialize Firebase Admin: $e',
      stackTrace: StackTrace.current,
    );
  }
})();

/// Firestore instance for database operations.
///
/// This singleton instance provides access to Cloud Firestore database operations.
/// Use it to perform CRUD operations, queries, and real-time updates on your data.
///
/// Common operations:
/// - Read documents and collections
/// - Write, update, and delete documents
/// - Perform complex queries
/// - Listen to real-time updates
/// - Batch operations and transactions
///
/// Example usage:
/// ```dart
/// // Create a document
/// await firestore.collection('users').doc('user123').set({
///   'name': 'John Doe',
///   'age': 30,
///   'email': 'john@example.com'
/// });
///
/// // Read a document
/// final docSnapshot = await firestore.doc('users/user123').get();
/// final userData = docSnapshot.data();
///
/// // Query with filters
/// final querySnapshot = await firestore
///     .collection('users')
///     .where('age', WhereFilter.greaterThan, 18)
///     .where('city', WhereFilter.equalTo, 'New York')
///     .get();
///
/// // Delete a document
/// await firestore.doc('users/user123').delete();
/// ```
final Firestore firestore = Firestore(admin);

/// Firebase Auth instance for authentication operations.
///
/// This singleton instance provides access to Firebase Authentication services.
/// Use it to manage users, verify tokens, and handle authentication-related
/// operations server-side.
///
/// Key capabilities:
/// - User management (create, update, delete)
/// - Token verification and generation
/// - User lookup by various identifiers
/// - Custom claims management
/// - Session management
///
/// Example usage:
/// ```dart
/// // Create a new user
/// final userRecord = await auth.createUser(
///   CreateUserRequest(
///     email: 'user@example.com',
///     password: 'securePassword123',
///     displayName: 'John Doe',
///     emailVerified: false,
///     disabled: false,
///   ),
/// );
///
/// // Verify an ID token
/// final decodedToken = await auth.verifyIdToken('user-provided-token');
/// final uid = decodedToken.uid;
///
/// // Update user properties
/// await auth.updateUser(
///   uid,
///   UpdateUserRequest(
///     emailVerified: true,
///     displayName: 'John Smith',
///   ),
/// );
///
/// // Delete a user
/// await auth.deleteUser(uid);
///
/// // Set custom claims
/// await auth.setCustomUserClaims(
///   uid,
///   {'admin': true, 'accessLevel': 5},
/// );
/// ```
final Auth auth = Auth(admin);


  /// Important: Cleanup Instructions
  ///
  /// When shutting down your application, it's crucial to properly close
  /// the Firebase Admin SDK to cleanup resources and connections.
  ///
  /// Example shutdown:
  /// ```dart
  /// // In your application shutdown logic:
  /// Future<void> shutdown() async {
  ///   await admin.close();
  ///   print('Firebase Admin SDK shutdown complete');
  /// }
  /// ```
  ///
  /// Failing to close the admin app may result in:
  /// - Memory leaks
  /// - Hanging connections
  /// - Incomplete operations
