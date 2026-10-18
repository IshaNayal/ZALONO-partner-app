import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  FirebaseService._();

  static bool isConfigured = false;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isConfigured = true;
    } on UnsupportedError {
      // Local UI development can run before FlutterFire configuration.
      isConfigured = false;
    }
  }

  static FirebaseAuth get auth {
    if (!isConfigured) {
      throw StateError(
        'Firebase is not configured. Run `flutterfire configure` first.',
      );
    }
    return FirebaseAuth.instance;
  }

  static User? get currentUser => isConfigured ? FirebaseAuth.instance.currentUser : null;

  static Future<User> ensureAuthenticated() async {
    if (!isConfigured) {
      throw StateError(
        'Firebase is not configured. Run `flutterfire configure` first.',
      );
    }
    final existingUser = FirebaseAuth.instance.currentUser;
    if (existingUser != null) {
      return existingUser;
    }
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw StateError('Firebase did not return an authenticated user.');
      }
      return user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'operation-not-allowed') {
        throw StateError(
          'Firebase Anonymous Authentication is disabled. '
          'Enable Anonymous under Firebase Console > Authentication > Sign-in method.',
        );
      }
      throw StateError(
        'Firebase authentication failed (${error.code}): ${error.message ?? 'Unknown error'}',
      );
    }
  }
}
