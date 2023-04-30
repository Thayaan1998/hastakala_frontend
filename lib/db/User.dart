import 'package:flutter/material.dart';

class User {
  final int userId;
  final String type;

  const User({
    required this.userId,
    required this.type
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type
    };
  }




  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $userId, type: $type}';
  }
}