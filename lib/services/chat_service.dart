/// Chat API Service
/// Handles all messaging and chat room related API calls
library chat_service;

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class ChatService {
  final ApiClient _api = ApiClient();

  /// List user's chat rooms
  Future<ChatRoomsResponse> listChatRooms() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.chatRooms,
    );
    return ChatRoomsResponse.fromJson(response);
  }

  /// Create a new chat room
  Future<ChatRoom> createChatRoom({
    required String participantId,
    String? contextType,
    String? contextId,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.chatRooms,
      data: {
        'participant_id': participantId,
        if (contextType != null) 'context_type': contextType,
        if (contextId != null) 'context_id': contextId,
      },
    );
    return ChatRoom.fromJson(response);
  }

  /// Get chat room details
  Future<ChatRoom> getChatRoom(String roomId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.chatRoom(roomId),
    );
    return ChatRoom.fromJson(response);
  }

  /// Get messages in a chat room
  Future<MessagesResponse> getMessages(
    String roomId, {
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.chatMessages(roomId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return MessagesResponse.fromJson(response);
  }

  /// Send a message
  Future<ChatMessage> sendMessage(
    String roomId, {
    required String content,
    String messageType = 'text',
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.chatMessages(roomId),
      data: {
        'content': content,
        'message_type': messageType,
      },
    );
    return ChatMessage.fromJson(response);
  }

  /// Delete a message
  Future<void> deleteMessage(String roomId, String messageId) async {
    await _api.delete('${ApiConfig.chatMessages(roomId)}/$messageId');
  }

  /// Report a message
  Future<Map<String, dynamic>> reportMessage(
    String roomId,
    String messageId,
    String reason,
  ) async {
    return await _api.post<Map<String, dynamic>>(
      '${ApiConfig.chatMessages(roomId)}/$messageId/report',
      data: {'reason': reason},
    );
  }

  /// Freeze a conversation (panic feature)
  Future<Map<String, dynamic>> freezeConversation(String roomId, String reason) async {
    return await _api.post<Map<String, dynamic>>(
      ApiConfig.freezeChat(roomId),
      data: {'reason': reason},
    );
  }
}

// Response Models

class ChatRoomsResponse {
  final List<ChatRoom> rooms;
  final int total;

  ChatRoomsResponse({required this.rooms, required this.total});

  factory ChatRoomsResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomsResponse(
      rooms: (json['rooms'] as List? ?? [])
          .map((r) => ChatRoom.fromJson(r))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class ChatRoom {
  final String roomId;
  final List<String> participants;
  final ChatMessage? lastMessage;
  final String? createdAt;

  ChatRoom({
    required this.roomId,
    required this.participants,
    this.lastMessage,
    this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['room_id'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['last_message'] != null 
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      createdAt: json['created_at'],
    );
  }
}

class MessagesResponse {
  final String roomId;
  final List<ChatMessage> messages;
  final int total;
  final int page;

  MessagesResponse({
    required this.roomId,
    required this.messages,
    required this.total,
    required this.page,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      roomId: json['room_id'] ?? '',
      messages: (json['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
    );
  }
}

class ChatMessage {
  final String messageId;
  final String roomId;
  final String senderId;
  final String content;
  final String messageType;
  final bool scamWarning;
  final String createdAt;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.scamWarning,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['message_id'] ?? '',
      roomId: json['room_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      messageType: json['message_type'] ?? 'text',
      scamWarning: json['scam_warning'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
