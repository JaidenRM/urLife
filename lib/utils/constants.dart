library constants;

import 'dart:math';

const String COLLECTION_USER = "users";
const String COLLECTION_ACTIVITY = "user-activities";

const String SUBCOLLECTION_ACTIVITY = "activities";

const String ACT_JOG = "Jog";
const String ACT_WALK = "Walk";
const String ACT_CYCLE = "Cycle";
const String ACT_SPRINT = "Sprint";

const String ROUTE_FITNESS = "/fitness";
const String ROUTE_ACTIVITY = "/fitness/activity";
const String ROUTE_ACTIVITY_HISTORY = "/fitness/activity/history";
const String ROUTE_TRACKER_HISTORY = "/fitness/tracker/history";

const int MAX_AGE = 120;
const int MAX_NAME_LENGTH = 100;
const int MAX_EMAIL_LENGTH = 255;

const int ZERO = 0;

const double SIZE_ICON_MD = 48.0;
const double SIZE_EARTH_RAD = 6371;
const double SIZE_ELLIPSOID_MAJOR = 6378137;
const double SIZE_ELLIPSOID_MINOR = 6356752.314245;

const double CNV_DEGREES_TO_RADIANS = pi / 180;
const double CNV_RADIANS_TO_DEGREES = 180 / pi;