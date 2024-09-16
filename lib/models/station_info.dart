
class StationInfo {
  final int id;
  final String name;
  final int direction;
  final double posX;
  final double posY;

  const StationInfo({
    required this.id,
    required this.name,
    required this.direction,
    required this.posX,
    required this.posY
  });

  StationInfo.fromJson(Map<String, dynamic> json) 
    : id = json['id'] as int,
    name = json['name'] as String,
    direction = json['direction'] as int,
    posX = json['posX'] as double,
    posY = json['posY'] as double;

}


