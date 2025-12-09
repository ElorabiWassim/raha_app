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

class ConversationMessagesLoading extends ConversationsState {
  final List<ConversationModel> conversations;

  const ConversationMessagesLoading(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationMessagesLoaded extends ConversationsState {
  final List<ConversationModel> conversations;
  final String conversationId;
  final List<ChatMessageModel> messages;

  const ConversationMessagesLoaded(
    this.conversations,
    this.conversationId,
    this.messages,
  );

  @override
  List<Object?> get props => [conversations, conversationId, messages];
}

class SendingMessage extends ConversationsState {
  final List<ConversationModel> conversations;

  const SendingMessage(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class MessageSent extends ConversationsState {
  final List<ConversationModel> conversations;
  final ChatMessageModel message;

  const MessageSent(this.conversations, this.message);

  @override
  List<Object?> get props => [conversations, message];
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
