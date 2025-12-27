import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import 'dart:async';

import '../../data/models/chat_message.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/api_response.dart';
import '../../cubits/conversations_cubit.dart';
import '../../cubits/conversations_state.dart';
import '../../data/repositories/conversations_repository.dart';
import '../../services/api_service.dart';
import '../themes/app_text_style.dart';
import '../../l10n/app_localizations.dart'; // Ensure this path is correct

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationsCubit(
        repository: ConversationsRepository(apiService: ApiService()),
      )..loadConversations(),
      child: const _MessagesScreenContent(),
    );
  }
}

class _MessagesScreenContent extends StatelessWidget {
  const _MessagesScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: BlocBuilder<ConversationsCubit, ConversationsState>(
                  builder: (context, state) {
                    // Show loading for initial state
                    if (state is ConversationsInitial ||
                        state is ConversationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Show error state
                    if (state is ConversationsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ConversationsCubit>()
                                    .loadConversations();
                              },
                              child: Text(AppLocalizations.of(context)!.actionRetry),
                            ),
                          ],
                        ),
                      );
                    }

                    // Extract conversations list from various states
                    List<ConversationModel> conversations = [];

                    if (state is ConversationsLoaded) {
                      conversations = state.conversations;
                    } else if (state is ConversationMessagesLoading) {
                      conversations = state.conversations;
                    } else if (state is ConversationMessagesLoaded) {
                      conversations = state.conversations;
                    } else if (state is SendingMessage) {
                      conversations = state.conversations;
                    } else if (state is MessageSent) {
                      conversations = state.conversations;
                    }

                    // Show conversations list if available
                    if (conversations.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          return _buildConversationCard(
                            context,
                            conversations[index],
                          );
                        },
                      );
                    }

                    // Show empty state
                    return _buildEmptyState(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7E6).withValues(alpha: .8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Container(width: 48, height: 48, alignment: Alignment.centerLeft),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.titleMessages,
            style: AppTextStyles.heading4.copyWith(color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(
    BuildContext context,
    ConversationModel conversation,
  ) {
    final lastMessage = conversation.lastMessage;
    final hasUnread = false; // TODO: Add unread count from backend
    final l10n = AppLocalizations.of(context)!;

    // Format time helper using Intl and Localization
    String formatTime(DateTime dateTime) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      final locale = Localizations.localeOf(context).toString();

      if (difference.inDays == 0) {
        return DateFormat.jm(locale).format(dateTime); // e.g., 5:30 PM or 17:30
      } else if (difference.inDays == 1) {
        return l10n.labelYesterday;
      } else if (difference.inDays < 7) {
        return DateFormat.E(locale).format(dateTime); // e.g., Mon, Tue, Lun, Mar
      } else {
        return DateFormat.yMd(locale).format(dateTime); // e.g., 10/25/2023
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasUnread
              ? AppColors.primary.withValues(alpha: .2)
              : const Color(0xFFE4E4E7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (navContext) => BlocProvider.value(
                  value: context.read<ConversationsCubit>(),
                  child: ConversationDetailScreen(
                    conversationId: conversation.conversationId,
                    otherUser: conversation.otherUser,
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: .1),
                  child: Text(
                    conversation.otherUser.fullName.isNotEmpty
                        ? conversation.otherUser.fullName[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Message Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation.otherUser.fullName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: hasUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (lastMessage != null)
                            Text(
                              formatTime(lastMessage.sentAt),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: hasUnread
                                    ? AppColors.primary
                                    : const Color(0xFF888888),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage?.text ?? l10n.msgNoMessagesYet,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: hasUnread
                                    ? AppColors.textDark
                                    : const Color(0xFF888888),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Unread Indicator
                if (hasUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.titleNoConversations,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.msgStartBookingToChat,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CONVERSATION DETAIL SCREEN
// =============================================================================

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;
  final dynamic otherUser; // Using dynamic to access properties safely

  const ConversationDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherUser,
  });

  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<ApiResponse<List<ChatMessageModel>>> _messagesStream;

  @override
  void initState() {
    super.initState();
    final repository = context.read<ConversationsCubit>().repository;
    _messagesStream = repository.getMessagesStream(widget.conversationId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    context.read<ConversationsCubit>().sendMessage(
      widget.conversationId,
      messageText,
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: StreamBuilder<ApiResponse<List<ChatMessageModel>>>(
                  stream: _messagesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final response = snapshot.data!;

                    if (!response.success) {
                      return Center(
                        child: Text(
                          response.error ?? l10n.msgFailedToLoadMessages,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    final messages = response.data ?? [];

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.msgNoMessagesYet,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.msgStartConversation,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _MessageBubble(message: messages[index]);
                      },
                    );
                  },
                ),
              ),
              _ChatInputField(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Determine role label based on user role
    String roleLabel = widget.otherUser.role == 'service_provider'
        ? l10n.roleServiceProvider
        : l10n.roleHomeowner;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7E6).withValues(alpha: .8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: .1),
            child: Text(
              widget.otherUser.fullName.isNotEmpty
                  ? widget.otherUser.fullName[0].toUpperCase()
                  : '?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.otherUser.fullName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  roleLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.textDark),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    
    return Align(
      alignment: message.sender.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.sender.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: message.sender.isMe ? AppColors.primary : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: message.sender.isMe
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
                bottomRight: message.sender.isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.sender.isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              DateFormat.jm(locale).format(message.sentAt),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputField({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.hintTypeMessage,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<ConversationsCubit, ConversationsState>(
            builder: (context, state) {
              final isSending = state is SendingMessage;
              return GestureDetector(
                onTap: isSending ? null : onSend,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      isSending ? Colors.grey : AppColors.primary,
                  child: isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}