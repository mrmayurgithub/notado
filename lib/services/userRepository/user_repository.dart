import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notado/models/user_model.dart';

class UserRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel userModel;

  // ignore: non_constant_identifier_names
  Future<void> LoginWithGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    AuthCredential credential;
    FirebaseAuth _auth = FirebaseAuth.instance;
    googleSignInAccount = await _googleSignIn.signIn();
    googleSignInAuthentication = await googleSignInAccount.authentication;
    credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    final _firebaseInstance = FirebaseAuth.instance;
    return await _firebaseInstance.signOut();
  }

  Future<String> getUID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<String> getUserEmail() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.email;
  }

  Future<String> getPhotoUrl() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.photoUrl;
  }

  Future<String> getDisplayName() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.displayName;
  }

  Future<bool> isSignedIn() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null;
  }
}
