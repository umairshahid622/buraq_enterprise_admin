import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      // Standardize the Pakistani number format
      String formattedPhone = AppUtils.getFormattedPhoneNumber(phoneNumber: phoneNumber);

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? "Verification failed.");
        },
        codeSent: (String verId, int? resendToken) {
          onCodeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } catch (e) {
      onError("An unexpected error occurred: $e");
    }
  }

  // Final Sign In
  Future<UserCredential> signInWithOtp(String verId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await _initializeUserRecord(userCredential.user);

      return userCredential;
    } on FirebaseAuthException {
      // Re-throw Firebase Auth exceptions so they can be handled upstream
      rethrow;
    } catch (e) {
      // Wrap other exceptions
      throw Exception("Sign in failed: $e");
    }
  }

  // Optional: Create the user record if it doesn't exist
  Future<void> _initializeUserRecord(User? user) async {
    if (user == null || user.phoneNumber == null) return;

    final userRef = _db.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'phone': user.phoneNumber,
        'first_name': "Admin",
        'last_name': "User",
        'role': Roles.admin.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUserData({int maxRetries = 3}) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Retry mechanism for first-time users where document might not be immediately readable
      for (int attempt = 0; attempt < maxRetries; attempt++) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          // Include uid in the returned data
          data['uid'] = user.uid;
          return data;
        }
        
        // If document doesn't exist yet, wait and retry (only for first few attempts)
        if (attempt < maxRetries - 1) {
          await Future.delayed(Duration(milliseconds: 200 * (attempt + 1)));
        }
      }
      return null;
    }
    return null;
  }

  Future<void> updateUser({required String firstName, required String lastName}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'first_name': firstName,
        'last_name': lastName,
      });
    }
  }

  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout Failed: $e");
    }
  }
}
