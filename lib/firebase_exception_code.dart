/// {@template firebase_exception_code}
/// Firebase Auth Exception Codes.
///
/// This class provides a centralized collection of Firebase authentication error codes
/// for consistent error handling across the application.
///
/// Example:
/// ```dart
/// try {
///   // Firebase auth operation
/// } catch (e) {
///   if (e.code == FirebaseExceptionCode.userNotFound) {
///     // Handle user not found error
///   }
/// }
/// ```
/// {@endtemplate}
library;

/// Abstract class representing Firebase exception codes.
abstract class FirebaseExceptionCode {
  /// Error code returned when attempting to use a credential that is already 
  /// associated with a different user account.
  ///
  /// This typically occurs during sign-in or account linking operations when the
  /// provided credential is already connected to another user account.
  static const String credentialAlreadyInUse = 'credential-already-in-use';

  /// Error code returned when attempting to perform an operation on a user
  /// that does not exist in Firebase Authentication.
  ///
  /// This can occur during sign-in attempts or when trying to perform operations
  /// like password reset for non-existent users.
  static const String userNotFound = 'user-not-found';

  /// Error code returned when the provided password is incorrect for the given
  /// user account.
  ///
  /// This occurs during sign-in attempts with email/password authentication.
  static const String wrongPassword = 'wrong-password';

  /// Error code returned when attempting to create a new account with an email
  /// that is already registered.
  ///
  /// This occurs during sign-up operations when the email is already in use.
  static const String emailAlreadyInUse = 'email-already-in-use';

  /// Error code returned when the provided email address format is invalid.
  ///
  /// This can occur during sign-up, sign-in, or when updating a user's email.
  static const String invalidEmail = 'invalid-email';

  /// Error code returned when too many requests have been made to Firebase
  /// Authentication in a short period.
  ///
  /// This is a rate-limiting error that occurs to prevent abuse. The client
  /// should wait before retrying the operation.
  static const String tooManyRequests = 'too-many-requests';

  /// Error code returned when attempting to authenticate with a disabled
  /// user account.
  ///
  /// User accounts can be disabled by administrators or automatically due to
  /// suspicious activity.
  static const String userDisabled = 'user-disabled';
}

/// Exception thrown when a Firebase operation fails.
///
/// This exception class provides structured error information for Firebase-related
/// errors, including a descriptive message and optional stack trace.
///
/// Example:
/// ```dart
/// try {
///   // Firebase operation
/// } catch (e) {
///   throw FirebaseException(
///     'Failed to initialize Firebase: ${e.toString()}',
///     stackTrace: StackTrace.current,
///   );
/// }
/// ```
class FirebaseException implements Exception {
  /// Creates a new [FirebaseException] with the given [message] and optional 
  /// [stackTrace].
  ///
  /// The [message] parameter provides details about what went wrong during the
  /// Firebase operation. The optional [stackTrace] parameter captures the stack
  /// trace at the point where the exception occurred.
  FirebaseException(this.message, {this.stackTrace});
  
  /// The error message describing what went wrong.
  ///
  /// This message should provide clear and actionable information about the error
  /// that occurred during the Firebase operation.
  final String message;

  /// The stack trace at the point where the exception was thrown.
  ///
  /// This can be useful for debugging and error reporting. May be null if no
  /// stack trace was provided when the exception was created.
  final StackTrace? stackTrace;

  @override
  String toString() => 'FirebaseException: $message';
}
