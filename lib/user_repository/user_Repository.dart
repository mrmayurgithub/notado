import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    AuthCredential credential;
    AuthResult result;
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _user;
    //TODO: Confirm whether we have to implement try catch bloc

    googleSignInAccount = await _googleSignIn.signIn();
    googleSignInAuthentication = await googleSignInAccount.authentication;
    credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    result = await _auth.signInWithCredential(credential);
    _user = result.user;

    //TODO: Use databaseService to create a firebase Document
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      //TODO: GoogleSignout or Not
      // _googleSignIn.signOut(),
    ]);
  }

  Future<void> signInWithCredentials({String email, String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();

      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser());
  }
}
