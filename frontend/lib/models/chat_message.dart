import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String senderEmoji;
  final String message;
  final DateTime timestamp;
  final String? replyToId;  // For replying to messages
  final String? imageUrl;   // For image messages

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.senderEmoji,
    required this.message,
    required this.timestamp,
    this.replyToId,
    this.imageUrl,
  });

  // Convert from Firestore
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      groupId: data['groupId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderEmoji: data['senderEmoji'] ?? '😎',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      replyToId: data['replyToId'],
      imageUrl: data['imageUrl'],
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'senderEmoji': senderEmoji,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'replyToId': replyToId,
      'imageUrl': imageUrl,
    };
  }
}