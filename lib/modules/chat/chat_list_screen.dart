import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('U${index + 1}')),
            title: Text('User ${index + 1}', style: AppTypography.subtitle1),
            subtitle: const Text('Last message content...', style: AppTypography.body2),
            trailing: const Text('10:00 AM', style: AppTypography.caption),
            onTap: () {
              // Navigate to Chat Room
              // context.pushNamed(RouteNames.chatRoom, params: {'id': '$index'});
            },
          );
        },
      ),
    );
  }
}
