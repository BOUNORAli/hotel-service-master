class Reservation {
  final int id;
  final String guestName;
  final String roomNumber;
  final String status;

  Reservation({required this.id, required this.guestName, required this.roomNumber, required this.status});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      guestName: json['guestName'],
      roomNumber: json['roomNumber'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guestName': guestName,
      'roomNumber': roomNumber,
      'status': status,
    };
  }
}
