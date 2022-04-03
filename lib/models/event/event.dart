class Event {
  String name;
  String dateTime;

  Event({required this.name, required this.dateTime});

  factory Event.fromMap(Map<String, dynamic> json) =>
      Event(name: json['name'], dateTime: json['datetime']);

  Map<String, dynamic> toMap() => {'name': name, 'datetime': dateTime};
}
