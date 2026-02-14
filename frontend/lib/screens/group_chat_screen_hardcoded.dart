import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/emoji_avatar.dart';

class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String senderEmoji;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.senderEmoji,
    required this.message,
    required this.timestamp,
  });
}

class GroupChatScreenHardcoded extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupEmoji;
  final String currentUserId;
  final String currentUserName;
  final String currentUserEmoji;

  const GroupChatScreenHardcoded({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupEmoji,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserEmoji,
  });

  @override
  State<GroupChatScreenHardcoded> createState() => _GroupChatScreenHardcodedState();
}

class _GroupChatScreenHardcodedState extends State<GroupChatScreenHardcoded> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _getInitialMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<ChatMessage> _getInitialMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '6',
        groupId: widget.groupId,
        senderId: widget.currentUserId,
        senderName: widget.currentUserName,
        senderEmoji: widget.currentUserEmoji,
        message: 'Same here! Can\'t wait to see the results 👀',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        id: '5',
        groupId: widget.groupId,
        senderId: 'user_3',
        senderName: 'Bob',
        senderEmoji: '🚀',
        message: 'Yeah! Got some great photos 📸',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: '4',
        groupId: widget.groupId,
        senderId: 'user_2',
        senderName: 'Alice',
        senderEmoji: '🎨',
        message: 'Did anyone complete yesterday\'s prompt?',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ),
      ChatMessage(
        id: '3',
        groupId: widget.groupId,
        senderId: widget.currentUserId,
        senderName: widget.currentUserName,
        senderEmoji: widget.currentUserEmoji,
        message: 'I\'m in! This is going to be fun! 🎉',
        timestamp: now.subtract(const Duration(minutes: 20)),
      ),
      ChatMessage(
        id: '2',
        groupId: widget.groupId,
        senderId: 'user_3',
        senderName: 'Bob',
        senderEmoji: '🚀',
        message: 'Absolutely! Let\'s do this! 💪',
        timestamp: now.subtract(const Duration(minutes: 25)),
      ),
      ChatMessage(
        id: '1',
        groupId: widget.groupId,
        senderId: 'user_2',
        senderName: 'Alice',
        senderEmoji: '🎨',
        message: 'Hey everyone! Ready for today\'s challenge? 🔥',
        timestamp: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          groupId: widget.groupId,
          senderId: widget.currentUserId,
          senderName: widget.currentUserName,
          senderEmoji: widget.currentUserEmoji,
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              widget.groupEmoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Group Chat',
                  style: TextStyle(
                    color: Color(0xFFA1A1B5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF006E).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFFF006E),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Demo Mode - Messages are stored locally',
                    style: TextStyle(
                      color: Color(0xFFA1A1B5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == widget.currentUserId;
                final showAvatar = index == 0 ||
                    _messages[index - 1].senderId != message.senderId;

                return _buildMessageBubble(message, isMe, showAvatar);
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1B263B),
              border: Border(
                top: BorderSide(color: Color(0xFF2D2D44), width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Message TextField
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B2A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2D2D44),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Send Button
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isMe,
    bool showAvatar,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar (for others)
          if (!isMe && showAvatar)
            EmojiAvatar(emoji: message.senderEmoji, size: 'sm'),
          if (!isMe && !showAvatar) const SizedBox(width: 40),

          const SizedBox(width: 8),

          // Message Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender name (for others)
                if (!isMe && showAvatar)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: const TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                // Message container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? const LinearGradient(
                            colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
                          )
                        : null,
                    color: isMe ? null : const Color(0xFF1B263B),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message text
                      Text(
                        message.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Timestamp
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFFA1A1B5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Avatar (for current user)
          if (isMe && showAvatar)
            EmojiAvatar(emoji: widget.currentUserEmoji, size: 'sm'),
          if (isMe && !showAvatar) const SizedBox(width: 40),
        ],
      ),
    );
  }
}
