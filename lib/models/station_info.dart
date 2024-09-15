
import 'dart:ffi';

class StationInfo {
  final int id;
  final String name;
  final int direction;
  final Double posX;
  final Double posY;

  const StationInfo({
    required this.id,
    required this.name,
    required this.direction,
    required this.posX,
    required this.posY
  });
}


