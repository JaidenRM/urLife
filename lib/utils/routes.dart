import 'package:flutter/cupertino.dart';
import 'package:urLife/screens/activity_screen.dart';
import 'package:urLife/screens/activity_history_screen.dart';
import 'package:urLife/screens/fitness_screen.dart';
import 'package:urLife/screens/tracker_history_screen.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class Routes {
  static Map<String, Widget Function(BuildContext)> routes =
  {
    Constants.ROUTE_FITNESS: (context) => FitnessScreen(),
    Constants.ROUTE_ACTIVITY: (context) => ActivityScreen(),
    Constants.ROUTE_ACTIVITY_HISTORY: (context) => ActivityHistoryScreen(),
    Constants.ROUTE_TRACKER_HISTORY: (context) => TrackerHistoryScreen(),
  };
}