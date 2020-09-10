import 'package:notado/packages/packages.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  String userName = '';

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
    final _firebaseInstance = FirebaseAuth.instance;
    return await _firebaseInstance.signOut();
    // return await Future.wait([
    //   _firebaseInstance.signOut(),
    // ]);
  }

  Future<void> signInWithCredentials({String email, String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // FirebaseUser _newuser;
  Future<void> signUp({String email, String password}) async {
    final _firebaseInstance = FirebaseAuth.instance;
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = await _firebaseInstance.currentUser();

    // return await user.sendEmailVerification();
    return await user.sendEmailVerification();
  }

  Future<void> sendVerificationEmail() async {
    final _firebaseAuthInstance = FirebaseAuth.instance;
    final FirebaseUser user = await _firebaseAuthInstance.currentUser();
    return await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    final _firebaseInstance = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseInstance.currentUser();
    user.reload();
    return user.isEmailVerified;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    final _firebaseInstance = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseInstance.currentUser();
    // return ((await user.isEmailVerified)).toString();
    return user.displayName;
  }

  Future<String> getPhotoUrl() async {
    final _firebaseInstance = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseInstance.currentUser();
    return user.photoUrl;
  }

  Future<String> getDisplayName() async {
    final _firebaseInstance = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseInstance.currentUser();
    return user.displayName;
  }

  Future<String> getUID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<bool> validatePassword(String password) async {
    var _firebaseUser = await FirebaseAuth.instance.currentUser();
    var _authCredentials = EmailAuthProvider.getCredential(
      email: _firebaseUser.email,
      password: password,
    );
    try {
      var authResult =
          await _firebaseUser.reauthenticateWithCredential(_authCredentials);
      print(authResult.user == null);
      return authResult.user == null;
    } catch (e) {
      return false;
    }
  }
}
