import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notado/models/user_model.dart';

class UserRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel _userModel;

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
    String _uid;
    String _email;
    String _photoUrl;
    String _displayName;
    _uid = await getUID();
    _email = await getUserEmail();
    _photoUrl = await getPhotoUrl();
    _displayName = await getDisplayName();
    _userModel = UserModel(
      uid: _uid,
      email: _email,
      photoUrl: _photoUrl,
      displayName: _displayName,
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

  getUserModel() {
    return _userModel;
  }

  Future<bool> isSignedIn() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null;
  }
}
