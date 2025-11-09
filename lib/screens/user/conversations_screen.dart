import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/models/conversation.dart';
import 'package:listynest/services/chat_service.dart';

class ConversationsScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: _chatService.getConversations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final conversations = snapshot.data!;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                title: Text(conversation.lastMessage),
                onTap: () => context.go('/chat/${conversation.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
