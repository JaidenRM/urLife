import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/activity_interface.dart';
import 'package:urLife/data/interfaces/user_interface.dart';
import 'package:urLife/data/repository/db/activity_db.dart';
import 'package:urLife/data/repository/db/user_db.dart';
import '../interfaces/data_retrieval_interface.dart';

class CloudFirestore implements DataRetrieval {
  @override
  UserData userData = UserDB();
  ActivityData activityData = ActivityDB();

  Firestore _db() => Firestore.instance;
  bool hasConnection() => _db() == null ? false : true;
}