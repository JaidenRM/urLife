import 'package:urLife/data/interfaces/user_interface.dart';

import '../interfaces/data_retrieval_interface.dart';

class CloudFirestore implements DataRetrieval {
  @override
  UserData userData;
}