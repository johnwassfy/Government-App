import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<AppUser?> register(String email, String password, String name, String role) async {
  try {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    AppUser user = AppUser(uid: result.user!.uid, email: email, name: name, role: role);
    
    // Debug log to help you verify this step
    print("Attempting to write user to Firestore...");
    await _db.collection('users').doc(user.uid).set(user.toMap());
    print("User successfully written to Firestore.");
    
    return user;
  } catch (e) {
    print("Registration error: $e"); // <-- helpful in debugging
    rethrow;
  }
}

  Future<AppUser?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getUser(result.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
