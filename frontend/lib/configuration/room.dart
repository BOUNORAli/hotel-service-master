class Room {
  final int id;
  final String name;
  final int capacity;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
    );
  }
}
