import 'package:flutter/material.dart';
import 'package:global_trust_hub/shared_widgets/custom_input.dart';
import 'package:global_trust_hub/modules/chat/message_bubble.dart';

class ChatRoomScreen extends StatelessWidget {
  final String userId;

  const ChatRoomScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with User $userId')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                MessageBubble(message: 'Hello!', isMe: false),
                MessageBubble(message: 'Hi there! How can I help?', isMe: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomInput(
                    hintText: 'Type a message...',
                    controller: TextEditingController(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
