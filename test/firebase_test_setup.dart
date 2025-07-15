import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';

// Mock classes for Firebase
class MockFirebaseApp extends Mock implements FirebaseApp {}

void setupFirebaseMocks() {
  // Simple Firebase mock setup
  // This prevents Firebase initialization errors in tests
}

// Simple function to check if Firebase is available
bool isFirebaseAvailable() {
  try {
    // Return false for tests to avoid Firebase calls
    return false;
  } catch (e) {
    return false;
  }
}
