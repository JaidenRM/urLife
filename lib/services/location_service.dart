import 'package:geolocator/geolocator.dart';
import 'package:urLife/models/Location.dart';

class LocationService {
  final Duration _updateEvery;
  final Geolocator _geolocator;

  LocationService({ Duration updateInterval, Geolocator geolocator })
    : _updateEvery = updateInterval ?? Duration(seconds: 5),
      _geolocator = geolocator ?? Geolocator();

  Stream<Future<Location>> start() async* {
    yield* Stream.periodic(
      _updateEvery, (_) async {
        Position position = await _geolocator.getCurrentPosition();
        return Location(position.latitude, position.longitude, position.timestamp);
      },
    );
  }
}