import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/user_interface.dart';
import '../interfaces/data_retrieval_interface.dart';

class CloudFirestore implements DataRetrieval {
  @override
  UserData userData;
  Firestore _db() => Firestore.instance;

  bool hasConnection() => _db() == null ? false : true;
}