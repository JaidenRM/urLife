import 'package:urLife/models/activity.dart';

abstract class ActivityData {
  Future<List<Activity>> getAllActivities();
  Future<bool> addActivity(Activity activity);
  Future<bool> updateActivity(Activity activity);
}