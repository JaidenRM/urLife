import 'package:urLife/data/interfaces/activity_interface.dart';
import 'package:urLife/data/interfaces/user_interface.dart';

import '../interfaces/data_retrieval_interface.dart';

class LocalCache implements DataRetrieval {
  @override
  UserData userData;
  ActivityData activityData;

}