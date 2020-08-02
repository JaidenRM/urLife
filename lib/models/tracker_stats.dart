import 'package:equatable/equatable.dart';

class TrackerStats extends Equatable {
  final double avgSpeed;
  final double fastestSpeed;
  final double slowestSpeed;
  final double totalMeters;
  final double totalSeconds;
  final double estEnergyBurnt;

  const TrackerStats({
    this.avgSpeed, this.fastestSpeed,
    this.slowestSpeed, this.totalMeters,
    this.totalSeconds, this.estEnergyBurnt
  });

  @override
  List<Object> get props => [
    avgSpeed, fastestSpeed, slowestSpeed,
    totalMeters, totalSeconds, estEnergyBurnt
  ];

  Map<String, double> toMap() {
    final map = <String, double> {
      "Avg. Speed": avgSpeed,
      "Fastest Speed": fastestSpeed,
      "Slowest Speed": slowestSpeed,
      "Total Meters": totalMeters,
      "Total Seconds": totalSeconds,
      "Est. Energy Burnt": estEnergyBurnt,
    };
    //not all values may be used, so remove useless ones
    map.removeWhere((key, value) => value == null || value <= 0);

    return map;
  }

}