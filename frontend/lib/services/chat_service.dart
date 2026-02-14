import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String senderEmoji,
    required String message,
    String? replyToId,
    String? imageUrl,
  }) async {
    final chatMessage = ChatMessage(
      id: '',  // Firestore will generate
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      senderEmoji: senderEmoji,
      message: message,
      timestamp: DateTime.now(),
      replyToId: replyToId,
      imageUrl: imageUrl,
    );

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessage.toFirestore());

    // Update last message in group
    await _firestore.collection('groups').doc(groupId).set({
      'lastMessage': message,
      'lastMessageTime': Timestamp.now(),
      'lastMessageSender': senderName,
    }, SetOptions(merge: true));
  }

  // Get messages stream (real-time)
  Stream<List<ChatMessage>> getMessages(String groupId, {int limit = 50}) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  // Load older messages (pagination)
  Future<List<ChatMessage>> loadOlderMessages(
    String groupId,
    DateTime beforeTime, {
    int limit = 20,
  }) async {
    final snapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .where('timestamp', isLessThan: Timestamp.fromDate(beforeTime))
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessage.fromFirestore(doc))
        .toList();
  }

  // Delete a message
  Future<void> deleteMessage(String groupId, String messageId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  // Mark messages as read (optional feature)
  Future<void> markAsRead(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).set({
      'readBy': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true));
  }
}