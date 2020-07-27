import 'package:urLife/models/activity.dart';

abstract class ActivityData {
  Future<List<Activity>> getAllActivities(String userId);
  Future<bool> addActivity(String userId, Activity activity);
  Future<bool> updateActivity(String userId, Activity activity);
}