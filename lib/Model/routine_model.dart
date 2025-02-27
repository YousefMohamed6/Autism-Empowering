import 'package:cloud_firestore/cloud_firestore.dart';

class Routines {
  String id;
  String name;
  String notes;
  DateTime startDate;

  Routines({
    required this.id,
    required this.name,
    required this.notes,
    required this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'notes': notes,
      'startDate': startDate,
    };
  }

  static Routines fromMap(Map<String, dynamic> map, String id) {
    return Routines(
      id: id,
      name: map['name'],
      notes: map['notes'],
      startDate: (map['startDate'] as Timestamp).toDate(),
    );
  }

  factory Routines.fromDocument(DocumentSnapshot doc) {
    return Routines(
      id: doc.id,
      name: doc['name'],
      notes: doc['notes'],
      startDate: (doc['startDate'] as Timestamp).toDate(),
    );
  }
  factory Routines.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Routines(
      id: doc.id,
      name: data['name'] ?? '',
      notes: data['notes'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
    );
  }
}
