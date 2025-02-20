import 'package:dotenv/dotenv.dart';

/// A utility class for managing environment variables and Firebase configuration.
///
/// This class provides a centralized way to access environment variables needed for
/// Firebase Admin SDK initialization and other application configurations.
/// It uses the `dotenv` package to load environment variables from a .env file.
///
/// Example usage:
/// ```dart
/// await Env.load();
/// final projectId = Env.projectId;
/// final firebaseCredentials = {
///   'type': Env.firebaseType,
///   'project_id': Env.projectId,
///   // ... other credentials
/// };
/// ```
class Env {
  static late DotEnv _env;

  /// Initializes and loads environment variables from .env file.
  ///
  /// This method should be called before accessing any environment variables.
  /// It includes platform environment variables by default.
  static Future<void> load() async {
    _env = DotEnv(includePlatformEnvironment: true)..load();
  }

  /// The type of Firebase service account (usually "service_account")
  static String get firebaseType =>
      _env['FIREBASE_TYPE'] ??
      (() {
        throw Exception('FIREBASE_TYPE is not set');
      })();

  /// The Firebase project ID from the service account
  static String get projectId =>
      _env['FIREBASE_PROJECT_ID'] ??
      (() {
        throw Exception('FIREBASE_PROJECT_ID is not set');
      })();

  /// The private key ID from the Firebase service account
  static String get privateKeyId =>
      _env['FIREBASE_PRIVATE_KEY_ID'] ??
      (() {
        throw Exception('FIREBASE_PRIVATE_KEY_ID is not set');
      })();

  /// The private key from the Firebase service account.
  ///
  /// This is used for authentication with Firebase Admin SDK.
  static String get privateKey =>
      _env['FIREBASE_PRIVATE_KEY'] ??
      (() {
        throw Exception('FIREBASE_PRIVATE_KEY is not set');
      })();

  /// The client email from the Firebase service account
  static String get clientEmail =>
      _env['FIREBASE_CLIENT_EMAIL'] ??
      (() {
        throw Exception('FIREBASE_CLIENT_EMAIL is not set');
      })();

  /// The client ID from the Firebase service account
  static String get clientId =>
      _env['FIREBASE_CLIENT_ID'] ??
      (() {
        throw Exception('FIREBASE_CLIENT_ID is not set');
      })();

  /// The authentication URI for Firebase services
  static String get authUri =>
      _env['FIREBASE_AUTH_URI'] ??
      (() {
        throw Exception('FIREBASE_AUTH_URI is not set');
      })();

  /// The token URI for Firebase authentication
  static String get tokenUri =>
      _env['FIREBASE_TOKEN_URI'] ??
      (() {
        throw Exception('FIREBASE_TOKEN_URI is not set');
      })();

  /// The authentication provider X.509 certificate URL
  static String get authProviderCertUrl =>
      _env['FIREBASE_AUTH_PROVIDER_X509_CERT_URL'] ??
      (() {
        throw Exception('FIREBASE_AUTH_PROVIDER_X509_CERT_URL is not set');
      })();

  /// The client X.509 certificate URL
  static String get clientCertUrl =>
      _env['FIREBASE_CLIENT_X509_CERT_URL'] ??
      (() {
        throw Exception('FIREBASE_CLIENT_X509_CERT_URL is not set');
      })();

  /// The API key for Firebase services
  static String get apiKey =>
      _env['API_KEY'] ??
      (() {
        throw Exception('API_KEY is not set');
      })();

  /// The secret key used for JWT token generation/validation
  static String get secretJwt =>
      _env['SECRET_JWT'] ??
      (() {
        throw Exception('SECRET_JWT is not set');
      })();

  /// Google Maps API Key
  static String get googleMapsApiKey =>
      _env['GOOGLE_MAPS_API_KEY'] ??
      (() {
        throw Exception('GOOGLE_MAPS_API_KEY is not set');
      })();
  
  /// Environment
  static bool get isDevelopment =>
      _env['ENVIRONMENT'] == 'development' ||
      _env['ENVIRONMENT'] == 'dev';

  /// Generates a map of Firebase credentials from environment variables.
  ///
  /// This is useful when initializing the Firebase Admin SDK programmatically
  /// instead of using a service-account.json file.
  ///
  /// Returns a Map containing all necessary Firebase service account credentials.
  static Map<String, dynamic> get firebaseCredentials => {
        'type': firebaseType,
        'project_id': projectId,
        'private_key_id': privateKeyId,
        'private_key': privateKey,
        'client_email': clientEmail,
        'client_id': clientId,
        'auth_uri': authUri,
        'token_uri': tokenUri,
        'auth_provider_x509_cert_url': authProviderCertUrl,
        'client_x509_cert_url': clientCertUrl,
      };
}
