import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urLife/data/data_factory.dart';
import 'package:urLife/models/Profile.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
    //If not present; instantiate internally so we can easily inject mock instances for testing
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken
      , accessToken: googleAuth.accessToken
    );

    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<void> signUp({String email, String password}) async {
    final x = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    return x;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  //Only returning email ATM but can return much more complex data like a 'User' data model
  Future<Profile> getUser() async {
    final userId = await _firebaseAuth.currentUser().then((user) => user.uid);
    return await DataFactory().dataSource.userData.getProfile(userId);
  }

  Future<bool> addOrUpdateUser(Profile profile, { bool update = false }) async {
    final userDb = DataFactory().dataSource.userData;
    final userId = await _firebaseAuth.currentUser().then((user) => user.uid);
    //will return an error if profile doesn't exist if we call this func
    if(update)
      return await userDb.updateProfile(userId, profile);
    
    return await userDb.addOrUpdateProfile(userId, profile);
  }
}