import 'package:cloud_firestore/cloud_firestore.dart';
class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> json, String id) {
    return MessageModel(
      id: id,
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
     timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
