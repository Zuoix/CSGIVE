// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cs_give/models/deposit_status.dart';

class UserStockRequest {
  final String userId;
  final String depositId;
  final DateTime createdOn;
  final DateTime updatedOn;
  final DepositStatus? status;

  UserStockRequest({
    required this.userId,
    required this.depositId,
    required this.createdOn,
    required this.updatedOn,
    this.status,
  });

  UserStockRequest copyWith({
    String? userId,
    String? depositId,
    DateTime? createdOn,
    DateTime? updatedOn,
    DepositStatus? status,
  }) {
    return UserStockRequest(
      userId: userId ?? this.userId,
      depositId: depositId ?? this.depositId,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'depositId': depositId,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'updatedOn': updatedOn.millisecondsSinceEpoch,
      'status': status?.toJson(),
    };
  }

  factory UserStockRequest.fromMap(Map<String, dynamic> map) {
    return UserStockRequest(
      userId: map['userId'] as String,
      depositId: map['depositId'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn'] as int),
      updatedOn: DateTime.fromMillisecondsSinceEpoch(map['updatedOn'] as int),
      status: map['status'] != null
          ? DepositStatus.fromJson(map['status'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStockRequest.fromJson(String source) =>
      UserStockRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserStockRequest(userId: $userId, depositId: $depositId, createdOn: $createdOn, updatedOn: $updatedOn, status: $status)';
  }

  @override
  bool operator ==(covariant UserStockRequest other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.depositId == depositId &&
        other.createdOn == createdOn &&
        other.updatedOn == updatedOn &&
        other.status == status;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        depositId.hashCode ^
        createdOn.hashCode ^
        updatedOn.hashCode ^
        status.hashCode;
  }
}
