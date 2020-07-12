import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/user_interface.dart';
import 'package:urLife/models/Profile.dart';
import '../../../utils/constants.dart' as Constants;

class UserDB implements UserData {
  final userCollection = Firestore.instance.collection(Constants.COLLECTION_USER);
  
  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final userDoc = userCollection.document(userId);
      return await userDoc.get().then((doc) => Profile.fromSnapshot(doc));
    } catch(_) {
      return null;
    }
  }

  @override
  Future<bool> addOrUpdateProfile(String userId, Profile profile) {
    final userDoc = userCollection.document(userId);
    return userDoc.setData(profile.toJson())
      .then((value) => true)
      .catchError((_) => false);
  }

  @override
  Future<bool> updateProfile(String userId, Profile profile) {
    final userDoc = userCollection.document(userId);
    return userDoc.updateData(profile.toJson())
      .then((value) => true)
      .catchError(() => false);
  }
}