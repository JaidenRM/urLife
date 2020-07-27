import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double lat;
  final double lng;
  final DateTime time;

  Location(this.lat, this.lng, this.time);

  factory Location.fromJson(Map<dynamic, dynamic> json) => _locationFromJson(json);
  Map<String, dynamic> toJson() => _locationToJson(this);

  @override
  List<Object> get props => [lat, lng, time];

  @override
  String toString() => 'Location { lat: $lat, lng: $lng, time: $time }';
}

Map<String, dynamic> _locationToJson(Location location) =>
  <String, dynamic> {
    'location': GeoPoint(location.lat, location.lng),
    'time': location.time,
  };

Location _locationFromJson(Map<dynamic, dynamic> json) =>
  Location(
    (json['location'] as GeoPoint).latitude,
    (json['location'] as GeoPoint).longitude,
    json['time'] as DateTime,
  );