import 'package:equatable/equatable.dart';

class TrackerStats extends Equatable {
  final double avgSpeed;
  final double fastestSpeed;
  final double slowestSpeed;
  final double totalDistance;
  final double totalTime;
  final double estEnergyBurnt;

  const TrackerStats({
    this.avgSpeed, this.fastestSpeed,
    this.slowestSpeed, this.totalDistance,
    this.totalTime, this.estEnergyBurnt
  });

  @override
  List<Object> get props => [
    avgSpeed, fastestSpeed, slowestSpeed,
    totalDistance, totalTime, estEnergyBurnt
  ];

}