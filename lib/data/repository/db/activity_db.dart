import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/activity_interface.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityDB implements ActivityData {
  final activityCollection = Firestore.instance.collection(Constants.COLLECTION_ACTIVITY);

  //work out how to make activity name unique (can we count number of fields in document? but might cost an extra read?)
  @override
  Future<bool> addActivity(String userId, Activity activity) {
    int index = 0;
    final actDoc = activityCollection.document(userId);

    // actDoc.get()
    //   .then((value) => index = value.data.length)
    //   .catchError((_) => false);
    var json = activity.toJson("activity" + index.toString());
    return actDoc.setData(json, merge: true)
      .then((value) => true)
      .catchError((_) => false);
  }

  @override
  Future<List<Activity>> getAllActivities(String userId) {
    try {
      List<Activity> activities = [];
      return activityCollection
        .document(userId)
        .get()
        .then((snapshot) {
          //convert the value of each field into an activity
          snapshot.data.forEach((key, val) {
            activities.add(Activity.fromJson(val));
          });

          return activities;
        })
        .catchError((_) => null);
    } catch(_) {
      return null;
    }
  }

  @override
  Future<bool> updateActivity(String userId, Activity activity) {
    
    throw UnimplementedError();
  }

}