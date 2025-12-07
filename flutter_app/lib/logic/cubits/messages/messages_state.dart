import 'package:equatable/equatable.dart';
import '../../../data/models/message.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<Message> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);

  @override
  List<Object> get props => [message];
}
