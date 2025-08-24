import 'package:cloud_firestore/cloud_firestore.dart';

class InquiryModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRead;

  InquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  factory InquiryModel.fromMap(Map<String, dynamic> map, String id) {
    return InquiryModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      message: map['message'] ?? '',
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      isRead: map['isRead'] ?? false,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    
    // Handle Firestore Timestamp
    if (value is Timestamp) {
      return value.toDate();
    }
    
    // Handle int (milliseconds since epoch)
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    
    // Handle DateTime
    if (value is DateTime) {
      return value;
    }
    
    // Handle String (ISO 8601)
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date string: $value');
        return DateTime.now();
      }
    }
    
    // Fallback for dynamic Timestamp (runtime check)
    if (value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate();
    }
    
    print('Unknown date type: ${value.runtimeType} - $value');
    return DateTime.now();
  }

  InquiryModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRead,
  }) {
    return InquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
