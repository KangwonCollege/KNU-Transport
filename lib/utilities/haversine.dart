import 'package:vector_math/vector_math.dart' as vector_math;
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';

// mean earth radius - https://en.wikipedia.org/wiki/Earth_radius#Mean_radius
const double earthRadius = 6371.0088;

double haversine(double latitude1, double longitude1, double latitude2, double longitude2) {
  double posX1 = vector_math.radians(latitude1);
  double posX2 = vector_math.radians(longitude1);
  double posY1 = vector_math.radians(latitude2);
  double posY2 = vector_math.radians(longitude2);

  double relativeX = posX1 - posX2;
  double relativeY = posY1 - posY2;

  double distance = (
    math.pow(math.sin(relativeX) * 0.5, 2)
     + math.cos(posX1) * math.cos(posX2)
     * math.pow(math.sin(relativeY) * 0.5, 2)
  );
  return math.asin(math.sqrt(distance)) * earthRadius * 2;
}