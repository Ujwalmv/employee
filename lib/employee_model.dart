import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final DateTime joiningDate;
  final bool isActive;

  Employee({
    required this.id,
    required this.name,
    required this.joiningDate,
    required this.isActive,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      name: data['name'] as String,
      joiningDate: (data['joiningDate'] as Timestamp).toDate(),
      isActive: data['isActive'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'joiningDate': Timestamp.fromDate(joiningDate),
      'isActive': isActive,
    };
  }
}