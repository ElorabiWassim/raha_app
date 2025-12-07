import 'package:equatable/equatable.dart';
import '../../../data/models/conversation_model.dart';

abstract class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object?> get props => [];
}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsLoaded extends ConversationsState {
  final List<ConversationModel> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationMessagesLoading extends ConversationsState {}

class ConversationMessagesLoaded extends ConversationsState {
  final String conversationId;
  final List<ChatMessageModel> messages;

  const ConversationMessagesLoaded(this.conversationId, this.messages);

  @override
  List<Object?> get props => [conversationId, messages];
}

class SendingMessage extends ConversationsState {}

class MessageSent extends ConversationsState {
  final ChatMessageModel message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class StartingConversation extends ConversationsState {}

class ConversationStarted extends ConversationsState {
  final ConversationModel conversation;

  const ConversationStarted(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ConversationsError extends ConversationsState {
  final String message;

  const ConversationsError(this.message);

  @override
  List<Object?> get props => [message];
}
