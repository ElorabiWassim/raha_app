class ConversationModel {
  final String conversationId;
  final OtherUser otherUser;
  final LastMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationModel({
    required this.conversationId,
    required this.otherUser,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversation_id'] ?? '',
      otherUser: OtherUser.fromJson(json['other_user'] ?? {}),
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class OtherUser {
  final String userId;
  final String fullName;
  final String role;

  OtherUser({required this.userId, required this.fullName, required this.role});

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? 'Unknown',
      role: json['role'] ?? '',
    );
  }
}

class LastMessage {
  final String messageId;
  final String text;
  final String? attachmentUrl;
  final String senderId;
  final DateTime sentAt;
  final bool isMine;

  LastMessage({
    required this.messageId,
    required this.text,
    this.attachmentUrl,
    required this.senderId,
    required this.sentAt,
    required this.isMine,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      messageId: json['message_id'] ?? '',
      text: json['text'] ?? '',
      attachmentUrl: json['attachment_url'],
      senderId: json['sender_id'] ?? '',
      sentAt: DateTime.parse(
        json['sent_at'] ?? DateTime.now().toIso8601String(),
      ),
      isMine: json['is_mine'] ?? false,
    );
  }
}

class ChatMessageModel {
  final String messageId;
  final String conversationId;
  final String text;
  final String? attachmentUrl;
  final DateTime sentAt;
  final MessageSender sender;

  ChatMessageModel({
    required this.messageId,
    required this.conversationId,
    required this.text,
    this.attachmentUrl,
    required this.sentAt,
    required this.sender,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['message_id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      text: json['text'] ?? '',
      attachmentUrl: json['attachment_url'],
      sentAt: DateTime.parse(
        json['sent_at'] ?? DateTime.now().toIso8601String(),
      ),
      sender: MessageSender.fromJson(json['sender'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message_text': text, 'attachment_url': attachmentUrl};
  }
}

class MessageSender {
  final String userId;
  final String fullName;
  final String role;
  final bool isMe;

  MessageSender({
    required this.userId,
    required this.fullName,
    required this.role,
    required this.isMe,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? 'Unknown',
      role: json['role'] ?? '',
      isMe: json['is_me'] ?? false,
    );
  }
}
