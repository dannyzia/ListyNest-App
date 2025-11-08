
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final Timestamp timestamp;

  Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.timestamp,
  });
}
