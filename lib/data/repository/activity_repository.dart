import 'dart:math';
import 'package:urLife/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urLife/data/data_factory.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/models/location.dart';
import 'package:urLife/models/tracker_stats.dart';
import 'package:urLife/utils/constants.dart' as Constants;

enum Formula {
  haversine,
  vincenty
}

///METs ratings that have been generalised to fit a broad spectrum of ratings for a specific activity.
///For example, jogging can be done at different speeds and this can change the rating quite a bit.
Map<String, double> activityMETSRating = 
  <String, double> {
    Constants.ACT_WALK: 3.0, //walk dog
    Constants.ACT_JOG: 7.0, //general jogging
    Constants.ACT_SPRINT: 23.0, //14mph running
    Constants.ACT_CYCLE: 7.5, //general cycling
  };

class ActivityRepository {

  //do this later
  TrackerStats calcTrackerStats(List<Location> locations, bool bestAccuracy,
    { String activityName, double weight }
  ) {
    if(locations == null || locations.length <= 1) return null;

    List<TrackerStats> mappedStats = [];

    for(int i = 0; i < locations.length; i++) {
      if(i == 0) continue;

      Formula formula = bestAccuracy ? Formula.vincenty : Formula.haversine;
      double dist = calcDistanceMs(locations[i], locations[i-1], formula);
      int timeElapsedMS = locations[i - 1].time.difference(locations[i].time).inMilliseconds;

      mappedStats.add(TrackerStats(
        avgSpeed: (dist / 1000) / (timeElapsedMS / 1000 / 60 / 60),
        totalMeters: dist,
        totalSeconds: timeElapsedMS / 1000.0,
        estEnergyBurnt: _calculateCalsBurntMETS(activityName, weight, timeElapsedMS / 1000.0 / 60)
      ));
    }

    return TrackerStats(
      avgSpeed: (mappedStats.map((stats) => stats.avgSpeed).reduce((a, b) => a + b) / mappedStats.length).roundToPlaces(2),
      fastestSpeed: mappedStats.map((stats) => stats.avgSpeed).reduce(max).roundToPlaces(2),
      slowestSpeed: mappedStats.map((stats) => stats.avgSpeed).reduce(min).roundToPlaces(2),
      totalMeters: mappedStats.map((stats) => stats.totalMeters).reduce((a, b) => a + b).roundToPlaces(2),
      totalSeconds: mappedStats.map((stats) => stats.totalSeconds).reduce((a, b) => a + b).roundToPlaces(2),
      estEnergyBurnt: mappedStats.map((stats) => stats.estEnergyBurnt).reduce((a, b) => a + b).roundToPlaces(2),
    );
  }
  ///Used to calculate the distance in meters between two coordinates on the Earth.
  ///`Haversine formula` or `Vincenty formula` is implemented to determine this distance.
  ///
  ///`Haversine` assumes perfect spheroid and is quicker whereas
  ///
  ///`Vincenty` assumes a more accurate oblate spheroid and is therefore more accurate but more complex
  double calcDistanceMs(Location loc1, Location loc2, Formula formula) {
    switch(formula) {
      case Formula.haversine:
        return _haversineDistanceMs(loc1, loc2);
      case Formula.vincenty:
        return _vincentyDistanceMs(loc1, loc2);
      default:
        return 0;
    }
  }

  Future<bool> addActivity(Activity activity) async {
    var activityDB = DataFactory().dataSource.activityData;

    return await activityDB.addActivity(activity);
  }

  Future<List<Activity>> getAllActivities() async {
    var activityDB = DataFactory().dataSource.activityData;

    return activityDB.getAllActivities();
  }
  
  double _haversineDistanceMs(Location loc1, Location loc2) {
    double dist = 0;
    
    final a =
      pow(sin((loc2.lat - loc1.lat) * Constants.CNV_DEGREES_TO_RADIANS / 2.0), 2) +
      cos(loc1.lat * Constants.CNV_DEGREES_TO_RADIANS) *
      cos(loc2.lat * Constants.CNV_DEGREES_TO_RADIANS) *
      pow(sin((loc2.lng - loc1.lng) * Constants.CNV_DEGREES_TO_RADIANS / 2.0), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    //distance in meters
    dist = Constants.SIZE_EARTH_RAD * 1000 * c;
    
    return dist;
  }

  double _vincentyDistanceMs(Location loc1, Location loc2) {
    double dist = 0;

    final double deltaLng = (loc2.lng - loc1.lng) * Constants.CNV_DEGREES_TO_RADIANS;
    final double flattening = (Constants.SIZE_ELLIPSOID_MAJOR - Constants.SIZE_ELLIPSOID_MINOR) / Constants.SIZE_ELLIPSOID_MAJOR;
    final double u1 = atan((1 - flattening) * tan(loc1.lat * Constants.CNV_DEGREES_TO_RADIANS));
    final double u2 = atan((1 - flattening) * tan(loc2.lat * Constants.CNV_DEGREES_TO_RADIANS));
    
    final double sinU1 = sin(u1), cosU1 = cos(u1);
    final double sinU2 = sin(u2), cosU2 = cos(u2);

    double cosSqrAlpha, sinSigma, cos2SigmaM, cosSigma, sigma;
    double lambda = deltaLng, lambdaP, maxIter = 100;

    do {
      double sinLambda = sin(lambda), cosLambda = cos(lambda);
      sinSigma = 
        sqrt(
          pow(cosU2 * sinLambda, 2) +
          pow((cosU1 * sinU2 - sinU1 * cosU2 * cosLambda), 2)
        );

      if(sinSigma == 0) return 0;

      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
      sigma = atan2(sinSigma, cosSigma);

      double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
      cosSqrAlpha = 1 - sinAlpha * sinAlpha;
      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqrAlpha;

      double c = flattening / 16 * cosSqrAlpha * (4 + flattening * (4 - 3 * cosSqrAlpha));
      lambdaP = lambda;
      lambda = deltaLng + (1 - c) * flattening * sinAlpha
        * (sigma + c * sinSigma
          * (cos2SigmaM + c * cosSigma
            * (-1 + 2 * cos2SigmaM * cos2SigmaM)
            )
          );
            
    } while ((lambda - lambdaP).abs() > 1e-12 && --maxIter > 0);

    if(maxIter == 0) return 0;

    double uSqr = cosSqrAlpha * (pow(Constants.SIZE_ELLIPSOID_MAJOR, 2) - pow(Constants.SIZE_ELLIPSOID_MINOR, 2))
      / pow(Constants.SIZE_ELLIPSOID_MINOR, 2);
    double a = 1 + uSqr / 16384
      * (4096 + uSqr * (-768 + uSqr * (-128 + uSqr * (74 - 47 * uSqr))));
    double b = uSqr / 1024 * (256 + uSqr * (-128 + uSqr * (74 - 47 * uSqr)));
    double deltaSigma = b * sinSigma
      * (cos2SigmaM + b / 4
        * (cosSigma
          * (-1 + 2 * pow(cos2SigmaM, 2) - b / 6 * cos2SigmaM
            * (-3 + 4 * pow(sinSigma, 2)
              * (-3 + 4 * pow(cos2SigmaM, 2))
              )
            )
          )
        );
    dist = Constants.SIZE_ELLIPSOID_MINOR * a * (sigma - deltaSigma);
    return dist;
  }

  double _calculateCalsBurntMETS(String activity, double weight, double minutesTaken) {
    if(!activityMETSRating.containsKey(activity)) return 0;

    return activityMETSRating[activity] * 3.5 * weight / 200 * minutesTaken;
  }
}