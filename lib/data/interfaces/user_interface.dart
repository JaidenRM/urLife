import 'package:urLife/models/Profile.dart';

abstract class UserData {
  Profile getProfile(String userId);
  bool updateProfile(Profile profile);
}