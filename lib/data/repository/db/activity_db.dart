import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urLife/data/interfaces/activity_interface.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityDB implements ActivityData {

  //work out how to make activity name unique (can we count number of fields in document? but might cost an extra read?)
  @override
  Future<bool> addActivity(Activity activity) async {
    final actCol = await _getCollectionRef();

    var json = activity.toJson();
    return await actCol.add(json)
      .then((value) => true)
      .catchError((err) {
        var x = err;
        return false;
      });
  }

  @override
  Future<List<Activity>> getAllActivities() async {
    try {
      List<Activity> activities = [];
      final activityCollection = await _getCollectionRef();
      return activityCollection.getDocuments()
        .then((snapshot) {
          //convert the value of each field into an activity
          snapshot.documents.forEach((doc) {
            activities.add(Activity.fromJson(doc.data));
          });

          return activities;
        })
        .catchError((e) {
          var x = e;
          return null;
        });
    } catch(err) {
      var x = err;
      return null;
    }
  }

  @override
  Future<bool> updateActivity(Activity activity) {
    
    throw UnimplementedError();
  }

  Future<CollectionReference> _getCollectionRef() async {
    final currUser = await FirebaseAuth.instance.currentUser();

    return Firestore.instance.collection(
      Constants.COLLECTION_ACTIVITY 
      + "/" + currUser.uid
      + "/" + Constants.SUBCOLLECTION_ACTIVITY
    );
  }

}