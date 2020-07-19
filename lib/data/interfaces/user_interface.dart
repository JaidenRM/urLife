import 'package:urLife/models/Profile.dart';

abstract class UserData {
  Future<Profile> getProfile(String userId);
  Future<bool> addOrUpdateProfile(String userId, Profile profile);
  Future<bool> updateProfile(String userId, Profile profile);
}