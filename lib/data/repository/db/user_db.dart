import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/user_interface.dart';
import 'package:urLife/models/Profile.dart';
import '../../../utils/constants.dart' as Constants;

class UserDB implements UserData {
  Firestore _db() => Firestore.instance;
  
  @override
  Profile getProfile(String userId) {
    try {
      final userDoc = _db().collection(Constants.COLLECTION_USER).document(userId);
    } catch(_) {

    }
  }

  @override
  bool updateProfile(Profile profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}