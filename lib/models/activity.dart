import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:urLife/models/location.dart';

class Activity extends Equatable {

  final String activityName;
  final List<Location> locations;

  DocumentReference docRef;
  
  Activity({ this.activityName, this.locations });
  
  factory Activity.fromSnapshot(DocumentSnapshot snapshot) {
    Activity ssProfile = Activity.fromJson(snapshot.data);
    ssProfile.docRef = snapshot.reference;
    return ssProfile;
  }
  factory Activity.fromJson(Map<dynamic, dynamic> json) => _activityFromJson(json);
  Map<String, dynamic> toJson(String mapName) => _activityToJson(this, mapName);

  @override
  List<Object> get props => [];
}

//helpers
Map<String, dynamic> _activityToJson(Activity activity, String mapName) {
  var locs = activity.locations.map((loc) => loc.toJson());
  var locations = locs.toList();
  
  return <String, dynamic> {
    mapName: <String, dynamic> {
      'name': activity.activityName,
      'locations': locations,
    }
  };
}

Activity _activityFromJson(Map<dynamic, dynamic> json) =>
  Activity(
    activityName: json['name'] as String,
    locations: List<Location>.from(json['locations'].map((loc) {
      Location.fromJson(loc);
    })),
  );