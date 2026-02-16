import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Expense({
    String? id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] == 1,
    );
  }

  Expense copyWith({
    String? title,
    double? amount,
    String? category,
    bool? isSynced,
  }) {
    return Expense(
      id: id,
      userId: userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
