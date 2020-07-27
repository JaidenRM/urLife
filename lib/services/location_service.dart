import 'package:geolocator/geolocator.dart';
import 'package:urLife/models/location.dart';

class LocationService {
  final Duration _updateEvery;
  final Geolocator _geolocator;
  final LocationAccuracy _locationAccuracy;
  final GeolocationPermission _geolocationPermission;
  final int _minDistanceToUpdate;

  LocationService({ 
    Duration updateInterval, Geolocator geolocator, int minDistanceToUpdate,
    LocationAccuracy locationAccuracy, GeolocationPermission geolocationPermission
  })
  : _updateEvery = updateInterval ?? Duration(seconds: 5),
    _geolocator = (geolocator ?? Geolocator())..forceAndroidLocationManager = true,
    _minDistanceToUpdate = minDistanceToUpdate ?? 5,
    _locationAccuracy = locationAccuracy ?? LocationAccuracy.best,
    _geolocationPermission = geolocationPermission ?? GeolocationPermission.location;

  Stream<Future<Location>> onInterval() async* {
    yield* Stream.periodic(
      _updateEvery, (_) async {
        Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: _locationAccuracy,
          locationPermissionLevel: _geolocationPermission
        );
        return Location(position.latitude, position.longitude, position.timestamp);
      },
    );
  }

  Stream<Location> onChange() async* {
    yield* _geolocator
      .getPositionStream(
        LocationOptions(accuracy: _locationAccuracy, distanceFilter: _minDistanceToUpdate),
        _geolocationPermission
      )
      .map((pos) => Location(pos.latitude, pos.longitude, pos.timestamp));
  }

  Future<Location> getCurrentLocation() async {
    final position = await _geolocator.getCurrentPosition(
      desiredAccuracy: _locationAccuracy,
      locationPermissionLevel: _geolocationPermission,
    );

    return Location(position.latitude, position.longitude, position.timestamp);
  }

    Stream<Location> onIntervalTest() async* {
    yield* Stream.periodic(
      _updateEvery, (i) {
        double incrVal = i * 0.001;
        Location loc = Location(-37.813629 + incrVal, 144.963058, DateTime.now());
        print(loc);
        return loc;
      },
    );
  }
}