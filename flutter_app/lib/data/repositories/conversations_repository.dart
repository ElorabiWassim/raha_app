import 'dart:async'; // Required for Stream and Future.delayed
import '../../services/api_service.dart';
import '../models/conversation_model.dart';
import '../models/api_response.dart';

class ConversationsRepository {
  final ApiService apiService;

  ConversationsRepository({required this.apiService});

 
  Stream<ApiResponse<List<ChatMessageModel>>> getMessagesStream(
    String conversationId, {
    Duration refreshInterval = const Duration(seconds: 2),
  }) async* {
    
    
    yield await getConversationMessages(conversationId);

   
    while (true) {
      await Future.delayed(refreshInterval);
      
     
      yield await getConversationMessages(conversationId);
    }
  }

  Future<ApiResponse<List<ConversationModel>>> getUserConversations() async {
    final response = await apiService.get('/api/conversations');

    if (response['success'] == true) {
      final List<dynamic> conversationsJson = response['data'] ?? [];
      final conversations = conversationsJson
          .map((json) => ConversationModel.fromJson(json))
          .toList();
      return ApiResponse(success: true, data: conversations);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load conversations',
      );
    }
  }


  Future<ApiResponse<List<ChatMessageModel>>> getConversationMessages(
    String conversationId,
  ) async {
    final response = await apiService.get(
      '/api/conversations/$conversationId/messages',
    );

    if (response['success'] == true) {
      final List<dynamic> messagesJson = response['data']?['messages'] ?? [];
      final messages = messagesJson
          .map((json) => ChatMessageModel.fromJson(json))
          .toList();
      return ApiResponse(success: true, data: messages);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load messages',
      );
    }
  }

  // Send a message in a conversation
  Future<ApiResponse<ChatMessageModel>> sendMessage(
    String conversationId,
    String messageText, {
    String? attachmentUrl,
  }) async {
    final response = await apiService
        .post('/api/conversations/$conversationId/messages', {
          'message_text': messageText,
          if (attachmentUrl != null) 'attachment_url': attachmentUrl,
        });

    if (response['success'] == true) {
      final message = ChatMessageModel.fromJson(response['data']);
      return ApiResponse(success: true, data: message);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to send message',
      );
    }
  }

  // Start a new conversation
  Future<ApiResponse<ConversationModel>> startConversation(
    String otherUserId,
  ) async {
    final response = await apiService.post('/api/conversations', {
      'other_user_id': otherUserId,
    });

    if (response['success'] == true) {
      final conversation = ConversationModel.fromJson(response['data']);
      return ApiResponse(success: true, data: conversation);
    } else {
      // Check if conversation already exists
      if (response['message'] == 'Conversation already exists' &&
          response['data'] != null) {
        final conversation = ConversationModel.fromJson(response['data']);
        return ApiResponse(success: true, data: conversation);
      }
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to start conversation',
      );
    }
  }
}