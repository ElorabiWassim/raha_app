import 'package:flutter_bloc/flutter_bloc.dart';
import 'messages_state.dart';
import '../../../data/models/message.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  Future<void> loadMessages({bool fromLocalCache = false}) async {
    emit(MessagesLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    // Mock Data
    final messages = [
      Message(
        name: 'Karim B.',
        profileImage: 'https://i.pravatar.cc/150?img=12',
        lastMessage: 'I will be there in 15 minutes...',
        service: 'Cleaning',
        time: '10:45 AM',
        isUnread: true,
        isOnline: true,
        isOfflineSource: fromLocalCache,
      ),
      Message(
        name: 'Amina Z.',
        profileImage: 'https://i.pravatar.cc/150?img=47',
        lastMessage: 'Thank you for the great work!',
        service: 'Plumbing',
        time: 'Yesterday',
        isUnread: false,
        isOnline: false,
        isOfflineSource: fromLocalCache,
      ),
      Message(
        name: 'Yacine M.',
        profileImage: 'https://i.pravatar.cc/150?img=33',
        lastMessage: 'Can you come on Wednesday instead?',
        service: 'Gardening',
        time: 'Wed',
        isUnread: false,
        isOnline: false,
        isOfflineSource: fromLocalCache,
      ),
    ];

    emit(MessagesLoaded(messages));
  }

  Future<void> loadMessagesFromCache() => loadMessages(fromLocalCache: true);
}
