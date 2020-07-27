import 'package:firebase_auth/firebase_auth.dart';
import 'package:urLife/data/data_factory.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/models/location.dart';
import 'package:urLife/models/tracker_stats.dart';

class ActivityRepository {
  //do this later
  TrackerStats calcTrackerStats(List<Location> locations) {
    if(locations == null || locations.length == 0) return null;

    return TrackerStats(
      avgSpeed: 0
    );
  }
  //do this later
  double calcDistanceMs(Location loc1, Location loc2) {
    return 0;
  }

  Future<bool> addActivity(Activity activity) async {
    var activityDB = DataFactory().dataSource.activityData;
    var user = await FirebaseAuth.instance.currentUser();

    return activityDB.addActivity(user.uid, activity);
  }

  Future<List<Activity>> getAllActivities() async {
    var activityDB = DataFactory().dataSource.activityData;
    var user = await FirebaseAuth.instance.currentUser();

    return activityDB.getAllActivities(user.uid);
  }
}