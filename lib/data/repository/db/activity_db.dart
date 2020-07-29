import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urLife/data/interfaces/activity_interface.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityDB implements ActivityData {
  final activityCollection = Firestore.instance.collection(Constants.COLLECTION_ACTIVITY);

  //work out how to make activity name unique (can we count number of fields in document? but might cost an extra read?)
  @override
  Future<bool> addActivity(String userId, Activity activity) async {
    int index = 0;
    final actDoc = activityCollection.document(userId);

    await actDoc.get()
      .then((value) => index = value.exists ? value.data.length : 0)
      .catchError((_) => index = -1);
    
    if(index < 0) return await Future.delayed(Duration(microseconds: 1)).then((value) => false);

    var json = activity.toJson("activity" + index.toString());
    return await actDoc.setData(json, merge: true)
      .then((value) => true)
      .catchError((err) {
        var x = err;
        return false;

      });
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