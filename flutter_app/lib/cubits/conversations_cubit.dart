import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/conversations_repository.dart';
import '../data/models/conversation_model.dart';
import 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final ConversationsRepository repository;
  List<ConversationModel> _cachedConversations = [];

  ConversationsCubit({required this.repository})
    : super(ConversationsInitial());

  // Load all conversations for the user
  Future<void> loadConversations() async {
    emit(ConversationsLoading());

    final response = await repository.getUserConversations();

    if (response.success && response.data != null) {
      _cachedConversations = response.data!;
      emit(ConversationsLoaded(_cachedConversations));
    } else {
      emit(
        ConversationsError(response.error ?? 'Failed to load conversations'),
      );
    }
  }

  // Load messages for a specific conversation
  Future<void> loadMessages(String conversationId) async {
    emit(ConversationMessagesLoading(_cachedConversations));

    final response = await repository.getConversationMessages(conversationId);

    if (response.success && response.data != null) {
      emit(
        ConversationMessagesLoaded(
          _cachedConversations,
          conversationId,
          response.data!,
        ),
      );
    } else {
      emit(ConversationsError(response.error ?? 'Failed to load messages'));
    }
  }

  // Send a message
  Future<void> sendMessage(
    String conversationId,
    String messageText, {
    String? attachmentUrl,
  }) async {
    emit(SendingMessage(_cachedConversations));

    final response = await repository.sendMessage(
      conversationId,
      messageText,
      attachmentUrl: attachmentUrl,
    );

    if (response.success && response.data != null) {
      emit(MessageSent(_cachedConversations, response.data!));
      // Reload messages after sending
      await loadMessages(conversationId);
    } else {
      emit(ConversationsError(response.error ?? 'Failed to send message'));
    }
  }

  // Start a new conversation
  Future<void> startConversation(String otherUserId) async {
    emit(StartingConversation());

    final response = await repository.startConversation(otherUserId);

    if (response.success && response.data != null) {
      emit(ConversationStarted(response.data!));
      // Reload conversations list
      await loadConversations();
    } else {
      emit(
        ConversationsError(response.error ?? 'Failed to start conversation'),
      );
    }
  }

  // Refresh conversations
  Future<void> refreshConversations() async {
    await loadConversations();
  }
}
