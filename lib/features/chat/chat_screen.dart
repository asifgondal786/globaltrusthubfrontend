import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  String? _selectedChatId;

  final List<Map<String, dynamic>> _chats = [
    {
      'id': 'chat_1',
      'name': 'Ali Travel Consultants',
      'avatar': 'A',
      'lastMessage': 'Your visa documents look good. Let me know if you need any help.',
      'time': '2:30 PM',
      'unread': 2,
      'isOnline': true,
      'category': 'Education Agent',
    },
    {
      'id': 'chat_2',
      'name': 'University of Toronto',
      'avatar': 'U',
      'lastMessage': 'Thank you for your application. We will review it shortly.',
      'time': '11:45 AM',
      'unread': 0,
      'isOnline': false,
      'category': 'University',
    },
    {
      'id': 'chat_3',
      'name': 'Tech Innovate HR',
      'avatar': 'T',
      'lastMessage': 'We would like to schedule an interview next week.',
      'time': 'Yesterday',
      'unread': 1,
      'isOnline': true,
      'category': 'Employer',
    },
    {
      'id': 'chat_4',
      'name': 'StudentStay Housing',
      'avatar': 'S',
      'lastMessage': 'The apartment is available from next month.',
      'time': 'Yesterday',
      'unread': 0,
      'isOnline': false,
      'category': 'Housing',
    },
  ];

  final List<Map<String, dynamic>> _messages = [
    {'sender': 'them', 'text': 'Hello! How can I help you today?', 'time': '2:00 PM'},
    {'sender': 'me', 'text': 'Hi, I need help with my visa application for Canada.', 'time': '2:05 PM'},
    {'sender': 'them', 'text': 'Sure! I can help you with that. What type of visa are you applying for?', 'time': '2:10 PM'},
    {'sender': 'me', 'text': 'Student visa. I got admission to University of Toronto.', 'time': '2:15 PM'},
    {'sender': 'them', 'text': 'Congratulations! For a study permit, you will need:\n1. Acceptance letter\n2. Proof of funds\n3. Passport\n4. Medical exam\n5. Police clearance', 'time': '2:20 PM'},
    {'sender': 'me', 'text': 'I have all documents ready. Can you review them?', 'time': '2:25 PM'},
    {'sender': 'them', 'text': 'Your visa documents look good. Let me know if you need any help.', 'time': '2:30 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Mentor Connect'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: isDesktop
          ? Row(
              children: [
                // Chat List
                SizedBox(
                  width: 350,
                  child: _buildChatList(),
                ),
                const VerticalDivider(width: 1),
                // Chat Messages
                Expanded(
                  child: _selectedChatId != null
                      ? _buildChatMessages()
                      : _buildEmptyChatState(),
                ),
              ],
            )
          : _selectedChatId == null
              ? _buildChatList()
              : _buildChatMessages(),
    );
  }

  Widget _buildChatList() {
    return Column(
      children: [
        // Search
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        
        // Chats
        Expanded(
          child: ListView.builder(
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];
              final isSelected = chat['id'] == _selectedChatId;

              return Container(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                child: ListTile(
                  onTap: () => setState(() => _selectedChatId = chat['id']),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(chat['avatar'], style: const TextStyle(color: Colors.white)),
                      ),
                      if (chat['isOnline'] == true)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'],
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: (chat['unread'] as int) > 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat['time'],
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if ((chat['unread'] as int) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${chat['unread']}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    final chat = _chats.firstWhere((c) => c['id'] == _selectedChatId);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              if (!isDesktop)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _selectedChatId = null),
                ),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(chat['avatar'], style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat['name'], style: AppTypography.labelLarge),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: chat['isOnline'] == true ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          chat['isOnline'] == true ? 'Online' : 'Offline',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        Text('• ${chat['category']}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isMe = message['sender'] == 'me';

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isMe ? const Radius.circular(4) : null,
                      bottomLeft: !isMe ? const Radius.circular(4) : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['time'],
                        style: AppTypography.caption.copyWith(
                          color: isMe ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Select a conversation', style: AppTypography.h5.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Choose a chat from the list to start messaging', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'me',
          'text': _messageController.text.trim(),
          'time': 'Just now',
        });
        _messageController.clear();
      });
    }
  }
}
