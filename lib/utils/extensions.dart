import 'dart:math';

extension Rounding on double {
  double roundToPlaces(int decimalPlaces) {
    double mod = pow(10.0, decimalPlaces);
    return ((this * mod).round().toDouble() / mod);
  }
}