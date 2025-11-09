import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listynest/models/chat_message.dart';
import 'package:listynest/models/conversation.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Conversation>> getConversations() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('conversations')
          .where('participants', arrayContains: user.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Conversation.fromFirestore(doc)).toList());
    }
    return const Stream.empty();
  }

  Stream<List<ChatMessage>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String conversationId, String text) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'senderId': user.uid,
        'text': text,
        'timestamp': Timestamp.now(),
      });

      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': text,
        'lastMessageTimestamp': Timestamp.now(),
      });
    }
  }

  Future<String> createConversation(String otherUserId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final conversation = await _firestore.collection('conversations').add({
        'participants': [user.uid, otherUserId],
        'lastMessage': '',
        'lastMessageTimestamp': Timestamp.now(),
      });
      return conversation.id;
    }
    throw Exception('User not logged in');
  }
}
