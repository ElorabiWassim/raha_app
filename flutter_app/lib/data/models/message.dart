class Message {
  final String name;
  final String profileImage;
  final String lastMessage;
  final String service;
  final String time;
  final bool isUnread;
  final bool isOnline;
  final bool isOfflineSource;

  Message({
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.service,
    required this.time,
    this.isUnread = false,
    this.isOnline = false,
    this.isOfflineSource = false,
  });
}
