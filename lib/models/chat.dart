import 'message.dart';

class Chat {
  final String id;
  final String collectionPointId;
  final String collectionPointName;
  final String userId;
  final Message? lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.collectionPointId,
    required this.collectionPointName,
    required this.userId,
    this.lastMessage,
    this.unreadCount = 0,
  });
}
