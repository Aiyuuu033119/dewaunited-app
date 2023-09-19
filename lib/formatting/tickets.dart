class Ticket {
  final int eventID;
  final dynamic ticketingID;
  final String code;
  final dynamic name;
  final dynamic phone;
  final dynamic claimedAt;
  final String category;
  final String seatType;
  final dynamic sync;
  final dynamic no;

  const Ticket({
    required this.eventID,
    required this.ticketingID,
    required this.code,
    required this.name,
    required this.phone,
    required this.claimedAt,
    required this.category,
    required this.seatType,
    required this.sync,
    this.no,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        eventID: json['event_id'],
        ticketingID: json['ticketing_id'],
        code: json['code'],
        name: json['name'],
        phone: json['phone'],
        category: json['name'],
        seatType: json['category'],
        claimedAt: json['seat_type'],
        sync: json['sync'],
        no: json['no'],
      );

  Map<String, dynamic> toJson() => {
        'event_id': eventID,
        'ticketing_id': ticketingID,
        'code': code,
        'name': name,
        'phone': phone,
        'claimed_at': claimedAt,
        'category': category,
        'seat_type': seatType,
        'sync': sync,
        'no': no,
      };

  factory Ticket.toJson(Map<String, dynamic> json, eventID) => Ticket(
        eventID: eventID,
        ticketingID: json['id'],
        code: json['code'],
        name: json['name'],
        phone: json['phone'],
        category: json['category'],
        seatType: json['seat_type'],
        claimedAt: "",
        sync: 0,
        no: json['no'],
      );

  factory Ticket.toSync(Map<String, dynamic> json, eventID) => Ticket(
        eventID: eventID,
        ticketingID: json['ticketing_id'],
        code: json['code'],
        name: json['name'],
        phone: json['phone'],
        category: json['category'],
        seatType: json['seat_type'],
        claimedAt: json['claimed_at'],
        sync: json['sync'],
        no: json['no'],
      );

  Map<String, dynamic> toSync() => {
        'table_id': ticketingID,
        'claimed_at': claimedAt,
      };

  // factory Ticket.toJson(Map<String, dynamic> json, eventID) => {
  //       'eventID': eventID,
  //       'code': code,
  //       'name': name,
  //       'claimedAt': claimedAt,
  //       'sync': sync,
  //     };
}
