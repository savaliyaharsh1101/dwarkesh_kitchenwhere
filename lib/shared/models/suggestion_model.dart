import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionModel {
  final String id;
  final String productName;
  final String suggestion;
  final String? customerName;
  final String? customerEmail;
  final String? customerMobile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRead;
  final String priority; // low, medium, high
  final String status; // pending, in_review, planned, implemented, rejected

  SuggestionModel({
    required this.id,
    required this.productName,
    required this.suggestion,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
    this.priority = 'medium',
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'suggestion': suggestion,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerMobile': customerMobile,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isRead': isRead,
      'priority': priority,
      'status': status,
    };
  }

  factory SuggestionModel.fromMap(Map<String, dynamic> map, String id) {
    return SuggestionModel(
      id: id,
      productName: map['productName'] ?? '',
      suggestion: map['suggestion'] ?? '',
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerMobile: map['customerMobile'],
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      isRead: map['isRead'] ?? false,
      priority: map['priority'] ?? 'medium',
      status: map['status'] ?? 'pending',
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

  SuggestionModel copyWith({
    String? id,
    String? productName,
    String? suggestion,
    String? customerName,
    String? customerEmail,
    String? customerMobile,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRead,
    String? priority,
    String? status,
  }) {
    return SuggestionModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      suggestion: suggestion ?? this.suggestion,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerMobile: customerMobile ?? this.customerMobile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}
