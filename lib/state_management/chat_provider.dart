import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/chat_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum ChatStatus {
  initial,
  loading,
  loaded,
  sending,
  error,
}

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  ChatStatus _status = ChatStatus.initial;
  String? _errorMessage;
  
  // Data
  List<ChatRoom> _rooms = [];
  List<ChatMessage> _messages = [];
  ChatRoom? _currentRoom;
  
  // Pagination for messages
  int _currentPage = 1;
  bool _hasMoreMessages = true;

  // Getters
  ChatStatus get status => _status;
  bool get isLoading => _status == ChatStatus.loading;
  bool get isSending => _status == ChatStatus.sending;
  String? get errorMessage => _errorMessage;
  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messages;
  ChatRoom? get currentRoom => _currentRoom;
  bool get hasMoreMessages => _hasMoreMessages;

  /// Load all chat rooms
  Future<void> loadRooms() async {
    _status = ChatStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _chatService.listChatRooms();
      _rooms = response.rooms;
      _status = ChatStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ChatStatus.error;
    } catch (e) {
      _errorMessage = 'Failed to load conversations';
      _status = ChatStatus.error;
    }
    notifyListeners();
  }

  /// Create a new chat room
  Future<ChatRoom?> createRoom({
    required String participantId,
    String? contextType,
    String? contextId,
  }) async {
    try {
      final room = await _chatService.createChatRoom(
        participantId: participantId,
        contextType: contextType,
        contextId: contextId,
      );
      _rooms.insert(0, room);
      notifyListeners();
      return room;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Open a chat room and load messages
  Future<void> openRoom(String roomId) async {
    _status = ChatStatus.loading;
    _messages = [];
    _currentPage = 1;
    _hasMoreMessages = true;
    notifyListeners();

    try {
      // Get room details
      _currentRoom = await _chatService.getChatRoom(roomId);
      
      // Load messages
      final response = await _chatService.getMessages(roomId);
      _messages = response.messages;
      _hasMoreMessages = _messages.length < response.total;
      _currentPage++;
      _status = ChatStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ChatStatus.error;
    }
    notifyListeners();
  }

  /// Load more messages (pagination)
  Future<void> loadMoreMessages() async {
    if (!_hasMoreMessages || _status == ChatStatus.loading || _currentRoom == null) return;

    try {
      final response = await _chatService.getMessages(
        _currentRoom!.roomId,
        page: _currentPage,
      );
      _messages.addAll(response.messages);
      _hasMoreMessages = _messages.length < response.total;
      _currentPage++;
      notifyListeners();
    } catch (_) {
      // Non-critical
    }
  }

  /// Send a message
  Future<bool> sendMessage(String content, {String type = 'text'}) async {
    if (_currentRoom == null) return false;

    _status = ChatStatus.sending;
    notifyListeners();

    try {
      final message = await _chatService.sendMessage(
        _currentRoom!.roomId,
        content: content,
        messageType: type,
      );
      
      // Add to messages list
      _messages.insert(0, message);
      _status = ChatStatus.loaded;
      
      // Update room's last message in the rooms list
      final roomIndex = _rooms.indexWhere((r) => r.roomId == _currentRoom!.roomId);
      if (roomIndex != -1) {
        // Move to top of list
        final room = _rooms.removeAt(roomIndex);
        _rooms.insert(0, ChatRoom(
          roomId: room.roomId,
          participants: room.participants,
          lastMessage: message,
          createdAt: room.createdAt,
        ),);
      }
      
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ChatStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Freeze conversation (panic button)
  Future<bool> freezeConversation(String reason) async {
    if (_currentRoom == null) return false;

    try {
      await _chatService.freezeConversation(_currentRoom!.roomId, reason);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Report a message
  Future<bool> reportMessage(String messageId, String reason) async {
    if (_currentRoom == null) return false;

    try {
      await _chatService.reportMessage(_currentRoom!.roomId, messageId, reason);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Close current room
  void closeRoom() {
    _currentRoom = null;
    _messages = [];
    _status = ChatStatus.loaded;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
